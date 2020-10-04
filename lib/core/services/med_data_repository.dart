import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_data_box.dart';
import 'package:medical_history/core/services/repository.dart';

class MedDataRepository with ChangeNotifier implements Repository<MedData> {
  final container = ProviderContainer();
  final MedDataBox _medDataBox = locator();
  final Logger _l = locator();
  final String sectionName = 'MedDataRepository';

  Box _box;
  Stream _boxStream;
  List<MedData> _meds = [];
  int _numUsers = 0;

  MedDataRepository() {
    _l.initSectionPref(sectionName);

    _medDataBox.addListener(boxOpened);
    container.read(userProvider).addListener(_refreshMeds);
    _initialize();
  }

  bool get onlyOneUser => _numUsers == 1;

  void _refreshMeds() async {
    _meds = await _getAll();
  }

  /// This is required because Hive.openBox()
  ///  does not emit a BoxEvent.  It will only
  ///  be triggered once.
  void boxOpened() {
    _l.log(sectionName, 'Med box Opened event, refresh list.');
    notifyListeners();
    _medDataBox.removeListener(boxOpened);
  }

  @override
  void dispose() {
    _box.close();
    _l.log(sectionName, 'Doctor box closed.');
    container.read(userProvider).removeListener(_refreshMeds);
    _medDataBox.removeListener(boxOpened);
    super.dispose();
  }

  void _initialize() async {
    _l.log(sectionName, 'Initializing...');

    _box = await _medDataBox.box;
    _l.log(sectionName, 'got box');

    _meds = await _getAll();

    _boxStream = _box.watch();
    _boxStream.listen((event) async {
      _l.log(sectionName, 'BoxEvent occurred: reloading MedData');
      _meds = await _getAll();
    });
    _l.log(sectionName, '...complete');
  }

  @override
  MedData getAtIndex(int index) {
    if (index >= _meds.length) return null;
    return _meds[index];
  }

  MedData getByRxcui(String rxcui) {
    int index = _meds.indexWhere((element) => element.rxcui == rxcui);
    if (index == -1) return null;
    _l.log(sectionName, 'Returning: ${_meds[index].name}',
        linenumber: _l.lineNumber(StackTrace.current));
    return _meds[index];
  }

  @override
  MedData getByName(String name) {
    int index = _meds.indexWhere((element) => element.name == name);
    if (index == -1) return null;
    return _meds[index];
  }

  @override
  MedData getById(int id) {
    int index = _meds.indexWhere((element) => element.id == id);
    if (index == -1) return null;
    return _meds[index];
  }

  /// Refresh the repository list with sorted data from the box
  ///   Sorting is based on medication name field.
  ///   The list is filtered by the current logged-in user.
  Future<List<MedData>> _getAll() async {
    _numUsers = _countUniqueUsers();
    List<MedData> _medData;
    _medData = _box.values
        .toList()
        .where((med) => med.owner == container.read(userProvider).name)
        .toList();

    _medData.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    notifyListeners();
    return _medData;
  }

  int _countUniqueUsers() {
    List _userList = [];
    _userList.add(container.read(userProvider).name);
    List<MedData> _medData = _box.values.toList();
    for (var med in _medData) {
      if (!_userList.contains(med.owner)) _userList.add(med.owner);
    }
    _l.log(sectionName, 'Active users: ${_userList.toString()}',
        linenumber: _l.lineNumber(StackTrace.current));
    return _userList.length;
  }

  @override
  List<MedData> getAll() {
    return _meds;
  }

  @override
  Future<void> save(MedData newObject) async {
    int key;

    MedData _md = getByRxcui(newObject.rxcui);
    if (_md == null) {
      _md = newObject.copyWith(
        id: _box.length,
        mfg: newObject.mfg,
        doctorId: newObject.doctorId,
        dose: newObject.dose,
        frequency: newObject.frequency,
      );
    } else {
      key = _md.key;
      _md = _md.copyWith(
        id: key,
        mfg: newObject.mfg,
        doctorId: newObject.doctorId,
        dose: newObject.dose,
        frequency: newObject.frequency,
      );
    }

    if (key == null)
      _box.add(_md);
    else
      _box.put(key, _md);
    _l.log(sectionName, 'MedData saved: Doctor ID: ${newObject.doctorId}',
        linenumber: _l.lineNumber(StackTrace.current));
  }

  @override
  Future<void> delete(MedData objectToDelete) async {
    _l.log(sectionName, 'Deleting ${objectToDelete.name}',
        linenumber: _l.lineNumber(StackTrace.current));
    await _box.delete(objectToDelete.key);
  }

  @override
  Future<void> deleteAll() async {
    for (var med in _meds) {
      if (med.owner == container.read(userProvider).name) delete(med);
    }

    /// After meds deleteAll(), current user has no meds therefore un-count current user
    _numUsers = _countUniqueUsers() - 1;
    if (_numUsers < 1) _numUsers = 1;
  }

  @override
  int size() => _meds.length;

  @override
  Future deleteBox() async {
    _l.log(sectionName, 'Deleting MedBox');
    await _medDataBox.deleteBox();
    return null;
  }
}
