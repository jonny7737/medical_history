import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/services/doctor_data_box.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/repository.dart';
import 'package:medical_history/core/locator.dart';

class DoctorDataRepository with ChangeNotifier implements Repository<DoctorData> {
  final Logger _l = locator();
  final String sectionName = 'DoctorDataRepository';
  DoctorDataBox _doctorDataBox = locator();

  Box _box;
  bool _initialized = false;
  Stream _boxStream;
  List<DoctorData> _doctors = [];

  DoctorDataRepository() {
    _l.initSectionPref(sectionName);
    _doctorDataBox.addListener(boxOpened);
  }

  /// This is required because Hive.openBox()
  ///  does not emit a BoxEvent.  It will only
  ///  be triggered once.
  void boxOpened() async {
    _l.log(sectionName, 'Doctor box Opened event.');
    await _initialize();
    _doctors = await _getAll();
    notifyListeners();
    _doctorDataBox.removeListener(boxOpened);
  }

  @override
  void dispose() {
    _box.close();
    _l.log(sectionName, 'Doctor box closed.');
    _doctorDataBox.removeListener(boxOpened);
    super.dispose();
  }

  _initialize() async {
    _l.log(sectionName, 'Initializing: ${!_initialized}');

    _box = await _doctorDataBox.box;
    _l.log(sectionName, 'got box', linenumber: _l.lineNumber(StackTrace.current));

    _doctors = await _getAll();

    _boxStream = _box.watch();
    _boxStream.listen((event) async {
      _l.log(sectionName, '[DoctorDataRepository]: doctor list update needed');
      _doctors = await _getAll();
      notifyListeners();
    });
    _initialized = true;
    _l.log(sectionName, 'Initializing: ${!_initialized}');
  }

  @override
  DoctorData getAtIndex(int index) {
    if (index >= _doctors.length) return null;
    return _doctors[index];
  }

  @override
  DoctorData getByName(String name) {
    int index = _doctors.indexWhere((element) => element.name == name);
    if (index == -1) return null;
    return _doctors[index];
  }

  @override
  DoctorData getById(int id) {
    int index = id;
    if (index == -1) return null;
    return _doctors[index];
  }

  @override
  List<DoctorData> getAll() {
    return _doctors;
  }

  Future<List<DoctorData>> _getAll() async {
    do {
      await Future.delayed(Duration(milliseconds: 100));
    } while (_box == null);
    return _box.values.toList();
  }

  @override
  Future<void> save(DoctorData newObject) async {
    DoctorData _dd = getByName(newObject.name);
    int key;

    if (_box == null) print('Oh no!!!!  _box is NULL');

    if (_dd == null && newObject.id != -1) {
      _dd = getById(newObject.id);
    }

    _l.log(sectionName, 'ID: ${newObject.id} => $_dd',
        linenumber: _l.lineNumber(StackTrace.current));

    if (_dd == null) {
      _dd = newObject.copyWith(id: _box.length);
      _box.add(_dd);
    } else {
      key = _dd.key;
      _dd = newObject.copyWith(id: key);
      _box.put(key, _dd);
    }
    _l.log(sectionName, 'DoctorData saved: DoctorId:${_dd.id}, DoctorName:${_dd.name}',
        linenumber: _l.lineNumber(StackTrace.current));
  }

  @override
  Future<void> delete(DoctorData objectToDelete) async {
    _box.delete(objectToDelete.key);
    _doctors = await _getAll();
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  @override
  int size() => _doctors.length;

  @override
  Future deleteBox() async {
    await _doctorDataBox.deleteBox();
    return null;
  }
}
