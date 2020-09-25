import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as E;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage with ChangeNotifier {
  SecureStorage() {
    init();
  }

  E.Key key;
  E.IV iv;
  E.Encrypter encrypter;

  final storage = new FlutterSecureStorage();
  String beatleJuice = '';

  Map keyMap = {'ds': 'dbk'};
  Uint8List doctorBoxKey;
  String doctorStoreKey;

  void init() {
    key = E.Key.fromLength(32);
    iv = E.IV.fromLength(16);
    encrypter = E.Encrypter(E.AES(key));

    doctorStoreKey = keyMap['ds'];

    delete();

    storage.containsKey(key: doctorStoreKey).then((keyExists) async {
      do {
        await Future.delayed(Duration(milliseconds: 300));
      } while (beatleJuice.length < 20);
      if (!keyExists)
        buildAndSaveKey();
      else
        setBoxKey();
    });
  }

  void sBuilder(String p4) {
    beatleJuice += p4;
  }

  void buildAndSaveKey() {
    final encrypted = encrypter.encrypt(beatleJuice, iv: iv);
    save(encrypted.base64);
  }

  void delete() {
    storage.delete(key: doctorStoreKey).then((_) => update());
  }

  void save(String value) {
    storage.write(key: doctorStoreKey, value: value).then((_) {
      setBoxKey();
    });
  }

  void setBoxKey() {
    storage.read(key: doctorStoreKey).then((value) {
      final b64BoxKey = encrypter.decrypt64(value, iv: iv);
      final encrypted = encrypter.encrypt(b64BoxKey, iv: iv);
      doctorBoxKey = encrypted.bytes;
      update();
    });
  }

  void update() {
    notifyListeners();
  }
}
