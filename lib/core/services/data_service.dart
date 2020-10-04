import 'package:flutter/foundation.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/doctor_data_repository.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_data_repository.dart';
import 'package:medical_history/core/services/repository_service.dart';

class DataService with ChangeNotifier implements RepositoryService {
  final Logger _l = locator();
  final MedDataRepository _medRepository = locator();
  final DoctorDataRepository _doctorRepository = locator();
  final String sectionName = 'DataService';

  DataService() {
    _l.initSectionPref(sectionName);
    _medRepository.addListener(updatedMeds);
    _doctorRepository.addListener(updatedDoctors);
  }

  @override
  void dispose() {
    _medRepository.removeListener(updatedMeds);
    _doctorRepository.removeListener(updatedDoctors);
    super.dispose();
  }

  void updatedMeds() {
    _l.log(sectionName, 'Updating Meds list', linenumber: _l.lineNumber(StackTrace.current));
    notifyListeners();
  }

  void updatedDoctors() {
    _l.log(sectionName, 'Updating Doctors list', linenumber: _l.lineNumber(StackTrace.current));
    notifyListeners();
  }

  @override
  bool get onlyOneUser => _medRepository.onlyOneUser;

  @override
  int get numberOfMeds => _medRepository.size();
  MedData getMedAtIndex(int index) => _medRepository.getAtIndex(index);

  @override
  int get numberOfDoctors => _doctorRepository.size();

  @override
  List<MedData> getAllMeds() {
    List<MedData> medList = _medRepository.getAll();
    return medList;
  }

  MedData getMedByRxcui(String rxcui) {
    return _medRepository.getByRxcui(rxcui);
  }

  /// Returns a Name sorted list of doctors.
  ///
  /// Sort is from the 'name' field NOT lastName, firstName
  ///
  @override
  List<DoctorData> getAllDoctors() {
    List<DoctorData> doctorList = _doctorRepository.getAll()
      ..sort((a, b) => a.name.compareTo(b.name));
    return doctorList;
  }

  @override
  DoctorData getDoctorByName(String name) {
    return _doctorRepository.getByName(name);
  }

  @override
  DoctorData getDoctorById(int id) {
    return _doctorRepository.getById(id);
  }

  Future clearAllMeds() async {
    await _medRepository.deleteAll();
  }

  Future clearAllDoctors() async {
    await _doctorRepository.deleteAll();
  }

  @override
  Future<void> save(Object newObject, {int editIndex}) async {
    String _action;

    if (newObject is MedData) {
      MedData _md = _medRepository.getByRxcui(newObject.rxcui);

      if (_md == null)
        _action = 'ADDED';
      else
        _action = 'UPDATED';

      await _medRepository.save(newObject);
      _l.log(
        sectionName,
        'Medication $_action - ${newObject.name} [$editIndex]',
        linenumber: _l.lineNumber(StackTrace.current),
      );
    } else if (newObject is DoctorData) {
      DoctorData _dd = _doctorRepository.getById(newObject.id);
      if (_dd == null)
        _action = 'ADDED';
      else
        _action = 'UPDATED';

      await _doctorRepository.save(newObject);
      _l.log(sectionName, 'Doctor $_action - ${newObject.name}');
    }
  }

  @override
  Future<void> delete(Object objectToDelete) async {
    if (objectToDelete is MedData) {
      await _medRepository.delete(objectToDelete);
    }
    if (objectToDelete is DoctorData) {
      _doctorRepository.delete(objectToDelete);
      //log(sectionName,'Doctor Deleted: ${objectToDelete.name}');
    }
  }

  @override
  Future deleteDoctorBox() async {
    _doctorRepository.deleteBox();
    return null;
  }

  @override
  Future deleteMedBox() async {
    _medRepository.deleteBox();
    return null;
  }
}
