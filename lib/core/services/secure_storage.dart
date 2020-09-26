import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as E;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';

class SecureStorage with ChangeNotifier {
  SecureStorage() {
    _l.initSectionPref(sectionName);
    _init();
  }

  final Logger _l = locator();
  final String sectionName = 'SecureStorage';

  E.Key key;
  E.IV iv;
  E.Encrypter encrypter;

  final storage = FlutterSecureStorage();
  static const int arbitraryBugSize = 64;

  Map keyMap = {'ds': 'dbk'};
  Uint8List _doctorBoxKey;
  String doctorStoreKey;

  void _init() async {
    key = E.Key.fromLength(32);
    iv = E.IV.fromLength(16);
    encrypter = E.Encrypter(E.AES(key));

    doctorStoreKey = keyMap['ds'];

    /// This is for testing only!!!
    // _l.log(sectionName, 'Deleting from ketStore', linenumber: _l.lineNumber(StackTrace.current));
    // delete();

    await setBoxKey();
  }

  Future<bool> get doctorBoxKeySet async {
    bool keyExists = await storage.containsKey(key: doctorStoreKey);
    _l.log(sectionName, 'Is DBK set: $keyExists', linenumber: _l.lineNumber(StackTrace.current));
    return keyExists;
  }

  Uint8List get doctorBoxKey {
    _l.log(sectionName, 'Call to get DBK', linenumber: _l.lineNumber(StackTrace.current));
    if (_doctorBoxKey == null) getBoxKey();
    do {
      Future.delayed(Duration(milliseconds: 200));
    } while (_doctorBoxKey == null);
    Future.delayed(Duration(milliseconds: 500)).then((value) => _doctorBoxKey = null);
    return _doctorBoxKey;
  }

  bool isInRange(int cc) {
    if (cc > 32 && cc < 127) return true;
    return false;
  }

  StringBuffer beatleJuice = StringBuffer();
  bool ccBuilder(int cc) {
    if (beatleJuice.length == arbitraryBugSize) return true;
    if (isInRange(cc)) beatleJuice.writeCharCode(cc);
    return false;
  }

  void buildAndSaveKey() async {
    final encrypted = encrypter.encrypt(beatleJuice.toString(), iv: iv);
    await save(encrypted.base64);
  }

  Future delete() async {
    await storage.delete(key: doctorStoreKey);
    updateListeners();
  }

  Future save(String value) async {
    await storage.write(key: doctorStoreKey, value: value);
    await getBoxKey();
  }

  Future getBoxKey() async {
    String key = await storage.read(key: doctorStoreKey);
    final b64BoxKey = encrypter.decrypt64(key, iv: iv);
    final encrypted = encrypter.encrypt(b64BoxKey, iv: iv);
    _doctorBoxKey = encrypted.bytes;
    updateListeners();
  }

  Future setBoxKey() async {
    bool keyExists = await storage.containsKey(key: doctorStoreKey);
    if (!keyExists) {
      do {
        await Future.delayed(Duration(milliseconds: 300));
      } while (beatleJuice.length < arbitraryBugSize);

      _l.log(sectionName, 'Bug size is good.  Got beatle juice\n $beatleJuice',
          linenumber: _l.lineNumber(StackTrace.current));

      buildAndSaveKey();
    } else
      await getBoxKey();
  }

  void updateListeners() {
    notifyListeners();
  }
}
