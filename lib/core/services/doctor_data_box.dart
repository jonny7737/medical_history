import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/secure_storage.dart';

class DoctorDataBox with ChangeNotifier {
  final Logger _l = locator();
  final SecureStorage _ss = locator();
  final String sectionName = 'DoctorDataBox';

  static const int retryTime = 100; // milliseconds to wait for !_initializing
  static int bke = (100 / 4).round() + 7;
  static const int bks = 0;

  Box<DoctorData> _box;
  Uint8List _boxKey;
  bool _initialized = false;
  bool _initializing = false;
  bool _lockCheck = false;

  DoctorDataBox() {
    _l.initSectionPref(sectionName);
    _init();
    _l.log(sectionName, 'constructor completed');
  }

  void _init() async {
    if (_initializing) return;
    _initializing = true;
    await setBoxKey();
    _l.log(sectionName, 'Waiting for Hive Box init..',
        linenumber: _l.lineNumber(StackTrace.current));
    await initializeHiveBox();
    _initialized = true;

    /// This is required because Hive.openBox()
    ///  does not emit a BoxEvent
    notifyListeners();
  }

  Future setBoxKey() async {
    do {
      await Future.delayed(Duration(milliseconds: 100)).then((_) {
        _boxKey = _ss.doctorBoxKey;
      });
    } while (_boxKey == null);
  }

  Future<DoctorData> getByKey(key) async {
    DoctorData _dd = _box.get(key);
    return _dd;
  }

  Future<Box<DoctorData>> get box async {
    if (_box != null && _box.isOpen) {
      _lockCheck = false;
      _initializing = false;
      _initialized = true;
      return _box;
    }
    _l.log(sectionName, 'Re-get on box');

    while (_lockCheck) {
      _l.log(sectionName, 'lockCheck wait');
      await Future.delayed(Duration(milliseconds: 50));
      if (_box != null && _box.isOpen) {
        _lockCheck = false;
        _initializing = false;
        _initialized = true;
        return _box;
      }
    }
    _lockCheck = true;

    if (_initializing) {
      _l.log(sectionName, 'initializing delay');
      int _totalDelay = 0;

      Future.doWhile(() {
        if (_totalDelay > 1000) {
          return false;
        }
        _totalDelay += retryTime;
        return Future.delayed(Duration(milliseconds: retryTime), () {
          bool continueLoop = !_initialized;
          return continueLoop;
        });
      });

      if (_initialized) {
        _initializing = false;
        _lockCheck = false;
        return _box;
      }
    }

    if (!_initialized) {
      _initializing = true;
      await initializeHiveBox();
      _initialized = true;
    }
    _initializing = false;
    _lockCheck = false;
    return _box;
  }

  Future<void> initializeHiveBox() async {
    if (_lockCheck) return;
    _lockCheck = true;
    _l.log(sectionName, 'Is box open? ${Hive.isBoxOpen(kDoctorHiveBox)}');
    _l.log(sectionName, 'awaiting Hive Box');

    _box = await Hive.openBox<DoctorData>(kDoctorHiveBox,
        encryptionCipher: HiveAesCipher(_boxKey.sublist(bks, bke)));
    if (_box != null) {
      _l.log(sectionName, 'Hive Box retrieved');
      if (_box.isOpen) _l.log(sectionName, 'DoctorData box is opened with ${_box.length} entries.');
    } else
      _l.log(sectionName, 'No Hive Box');
    _lockCheck = false;
  }

  Future deleteBox() async {
    await Hive.deleteBoxFromDisk(kDoctorHiveBox);
  }
}
