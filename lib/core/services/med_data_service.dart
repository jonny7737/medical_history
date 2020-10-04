import 'package:flutter/foundation.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_data_repository.dart';
import 'package:medical_history/core/services/repository_service.dart';

class MedDataService with ChangeNotifier implements RepositoryService {
  final Logger _l = locator();
  final MedDataRepository _medRepository = locator();
  final String sectionName = 'MedDataService';

  MedDataService() {
    _l.initSectionPref(sectionName);
    _medRepository.addListener(updatedMeds);
  }

  @override
  void dispose() {
    _medRepository.removeListener(updatedMeds);
    super.dispose();
  }

  void updatedMeds() {
    _l.log(sectionName, 'Updating Meds list', linenumber: _l.lineNumber(StackTrace.current));
    notifyListeners();
  }

  @override
  bool get onlyOneUser => _medRepository.onlyOneUser;

  @override
  int get numberOfMeds => _medRepository.size();
  MedData getMedAtIndex(int index) => _medRepository.getAtIndex(index);

  @override
  List<MedData> getAllMeds() {
    List<MedData> medList = _medRepository.getAll();
    return medList;
  }

  MedData getMedByRxcui(String rxcui) {
    return _medRepository.getByRxcui(rxcui);
  }

  Future clearAllMeds() async {
    await _medRepository.deleteAll();
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
    }
  }

  @override
  Future<void> delete(Object objectToDelete) async {
    if (objectToDelete is MedData) {
      await _medRepository.delete(objectToDelete);
    }
  }

  @override
  Future deleteMedBox() async {
    _medRepository.deleteBox();
    return null;
  }

  @override
  Future clearAllDoctors() {
    // TODO: implement clearAllDoctors
    throw UnimplementedError();
  }

  @override
  Future deleteDoctorBox() {
    // TODO: implement deleteDoctorBox
    throw UnimplementedError();
  }

  @override
  List<DoctorData> getAllDoctors() {
    // TODO: implement getAllDoctors
    throw UnimplementedError();
  }

  @override
  DoctorData getDoctorById(int id) {
    // TODO: implement getDoctorById
    throw UnimplementedError();
  }

  @override
  DoctorData getDoctorByName(String name) {
    // TODO: implement getDoctorByName
    throw UnimplementedError();
  }

  @override
  // TODO: implement numberOfDoctors
  int get numberOfDoctors => throw UnimplementedError();
}
