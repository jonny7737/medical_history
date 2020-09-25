import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';

class MedDataBox with ChangeNotifier {
  final Logger _l = locator();
  final String sectionName = 'MedDataBox';
  static const int retryTime = 100; // milliseconds to wait for !_initializing

  Box<MedData> _box;

  bool _initialized = false;
  bool _initializing = false;
  bool _lockCheck = false;

  MedDataBox() {
    _l.initSectionPref(sectionName);
    _init();
    _l.log(sectionName, 'constructor completed');
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() async {
    await initializeHiveBox(initCalling: true);
    _initialized = true;

    /// This is required because Hive.openBox()
    ///  does not emit a BoxEvent
    notifyListeners();
  }

  MedData getByKey(key) {
    return _box.get(key);
  }

  Future<Box<MedData>> get box async {
    if (_box != null && _box.isOpen) {
      _initializing = false;
      _lockCheck = false;
      _initialized = true;
      return _box;
    }
    _l.log(sectionName, 'Re-get on box');
    while (_lockCheck) {
      _l.log(sectionName, 'lockCheck delay', linenumber: _l.lineNumber(StackTrace.current));
      await Future.delayed(Duration(milliseconds: 20), () {});
      if (_box != null && _box.isOpen) {
        _lockCheck = false;
        _initializing = false;
        _initialized = true;
        _l.log(sectionName, 'LockCheck cleared with box',
            linenumber: _l.lineNumber(StackTrace.current));
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
        return Future.delayed(new Duration(milliseconds: retryTime), () {
          bool continueLoop = !_initialized;
          return continueLoop;
        });
      });

      if (_initialized) {
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

  Future<void> initializeHiveBox({bool initCalling = false}) async {
    if (_lockCheck) return;
    _lockCheck = true;
    _l.log(sectionName, 'Is box open? ${Hive.isBoxOpen(kMedHiveBox)}');
    _l.log(sectionName, 'awaiting Hive Box');
    _box = await Hive.openBox<MedData>(kMedHiveBox);
    if (_box != null) {
      _l.log(sectionName, 'Hive Box retrieved');
      if (_box.isOpen)
        _l.log(sectionName, 'MedData box is opened [$initCalling] with ${_box.length} entries.');
    } else
      _l.log(sectionName, 'No Hive Box');
    _lockCheck = false;
  }

  Future deleteBox() async {
    await Hive.deleteBoxFromDisk(kMedHiveBox);
  }
}
