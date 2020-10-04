import 'package:flutter/foundation.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/doctor_data_repository.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/repository_service.dart';

class DoctorDataService with ChangeNotifier implements RepositoryService {
  final Logger _l = locator();
  final DoctorDataRepository _doctorRepository = locator();
  final String sectionName = 'DoctorDataService';

  DoctorDataService() {
    _l.initSectionPref(sectionName);
    _doctorRepository.addListener(updatedDoctors);
  }

  @override
  void dispose() {
    _doctorRepository.removeListener(updatedDoctors);
    super.dispose();
  }

  void updatedDoctors() {
    _l.log(sectionName, 'Updating Doctors list', linenumber: _l.lineNumber(StackTrace.current));
    notifyListeners();
  }

  @override
  int get numberOfDoctors => _doctorRepository.size();

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

  Future clearAllDoctors() async {
    await _doctorRepository.deleteAll();
  }

  @override
  Future<void> save(Object newObject, {int editIndex}) async {
    String _action;

    if (newObject is DoctorData) {
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
  Future clearAllMeds() {
    // TODO: implement clearAllMeds
    throw UnimplementedError();
  }

  @override
  Future deleteMedBox() {
    // TODO: implement deleteMedBox
    throw UnimplementedError();
  }

  @override
  List<MedData> getAllMeds() {
    // TODO: implement getAllMeds
    throw UnimplementedError();
  }

  @override
  MedData getMedAtIndex(int index) {
    // TODO: implement getMedAtIndex
    throw UnimplementedError();
  }

  @override
  MedData getMedByRxcui(String rxcui) {
    // TODO: implement getMedByRxcui
    throw UnimplementedError();
  }

  @override
  // TODO: implement numberOfMeds
  int get numberOfMeds => throw UnimplementedError();

  @override
  // TODO: implement onlyOneUser
  bool get onlyOneUser => throw UnimplementedError();
}
