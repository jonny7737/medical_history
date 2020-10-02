import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/doctor_data_service.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_data_service.dart';
import 'package:medical_history/core/services/med_lookup_service.dart';
import 'package:medical_history/core/locator.dart';

class AddMedViewModel extends ChangeNotifier {
  final Logger _l = locator();
  final MedLookUpService _ls = locator();
  final MedDataService _medRepository = locator();
  final DoctorDataService _doctorRepository = locator();

  String sectionName;

  AddMedViewModel() {
    sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);
    _ls.addListener(setState);
  }

  bool _isDisposed = false;

  bool kbVisible;

  ScrollController formScrollController;
  void wasTapped(String fieldName) {
    if (formScrollController == null) return;
    if (fieldName == 'frequency')
      formScrollController.animateTo(150.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    else
      formScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    _l.log(sectionName, '$fieldName was tapped', linenumber: _l.lineNumber(StackTrace.current));
  }

  GlobalKey<FormState> formKey;
  void setFormKey(formKey) {
    this.formKey = formKey;
    _l.log(sectionName, 'FormKey set', linenumber: _l.lineNumber(StackTrace.current));
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _ls.removeListener(setState);
    _l.log(sectionName, 'Has been disposed.', linenumber: _l.lineNumber(StackTrace.current));
    super.dispose();
  }

  /// **********************************************************************
  String get newMedName => _ls.newMedName;
  String get fancyDoctorName {
    String _name;

    if (_ls.editIndex == null) {
      if (_ls.newMedDoctorName == null)
        _name = doctorNames[0];
      else
        _name = 'Dr. ' + _ls.newMedDoctorName;
    } else
      _name = 'Dr. ' + _ls.newMedDoctorName;
    return _name;
  }

  String reformatMedName(String medName, String dose) {
    String _newName = '';
    List<String> _nameSplit = medName.split(' ');
    for (int i = 0; i < _nameSplit.length; i++) {
      if (dose.startsWith(_nameSplit[i])) {
        for (int j = 0; j < i; j++) {
          _newName = _newName + _nameSplit[j] + ' ';
        }
        break;
      }
    }
    return _newName;
  }

  MedData get medAtEditIndex =>
      _ls.editIndex != null ? _medRepository.getMedAtIndex(_ls.editIndex) : null;

  void setMedForEditing(int index) {
    if (index == null) {
      return;
    }

    _ls.editIndex = index;
    MedData _md = medAtEditIndex;

    _l.log(sectionName, '${_md.doctorId}', linenumber: _l.lineNumber(StackTrace.current));

    _ls.newMedName = reformatMedName(_md.name, _md.dose);
    _ls.newMedDose = _md.dose;
    _ls.newMedFrequency = _md.frequency;
    if (_ls.newMedDoctorId == null) _ls.newMedDoctorId = _md.doctorId;
    _ls.newMedDoctorName = getDoctorById(_ls.newMedDoctorId).name;

    _l.log(sectionName, '${_md.doctorId}', linenumber: _l.lineNumber(StackTrace.current));
  }

  String formInitialValue(String fieldName) {
    String value;
    if (fieldName == 'name') value = _ls.newMedName;
    if (fieldName == 'dose') value = _ls.newMedDose;
    if (fieldName == 'frequency') value = _ls.newMedFrequency;

    return value;
  }

  void _setMedDoctorId(String name) {
    if (name.toLowerCase().startsWith('dr.')) {
      int i = name.indexOf(' ') + 1;
      name = name.substring(i);
    }
    _ls.newMedDoctorName = name;
    _ls.newMedDoctorId = _doctorRepository.getDoctorByName(name).id;
    _l.log(sectionName, '${_ls.newMedDoctorName}:${_ls.newMedDoctorId}',
        linenumber: _l.lineNumber(StackTrace.current));
  }

  bool onFormSave(String formField, String value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      if (formField == 'name') _ls.newMedName = value;
      if (formField == 'dose') _ls.newMedDose = value;
      if (formField == 'frequency') _ls.newMedFrequency = value;
      if (formField == 'doctor') {
        if (value.toLowerCase().startsWith('dr.')) {
          int i = value.indexOf(' ') + 1;
          value = value.substring(i);
        }
        _setMedDoctorId(value);
        notifyListeners();
      }
      return true;
    }
  }

  void logEditIndex() {
    if (_ls.editIndex == null) return;
    MedData _md = _medRepository.getMedAtIndex(_ls.editIndex);
    _l.log(
      sectionName,
      '$_ls.editIndex: ${_md.name} : ${_md.doctorId}',
      linenumber: _l.lineNumber(StackTrace.current),
    );
  }

  DoctorData getDoctorById(int id) => _doctorRepository.getDoctorById(id);

  List<String> get doctorNames {
    List<String> _doctorNames = [];
    List<DoctorData> _dd = _doctorRepository.getAllDoctors();
    for (var element in _dd) {
      _doctorNames.add('Dr. ' + element.name);
    }
    return _doctorNames;
  }

  List<Map<String, String>> doctorsForDropDown() {
    List<Map<String, String>> doctors = [];

    for (String doctor in doctorNames) {
      doctors.add({'display': doctor, 'value': doctor});
    }

    return doctors;
  }

  /// **********************************************************************

  /// **********************************************************************
  bool get wasMedAdded => _ls.wasMedAdded;

  bool get medsLoaded => _ls.medsLoaded;
  int get numMedsFound => _ls.numMedsFound;
  String get rxcuiComment => _ls.rxcuiComment;
  bool get hasNewMed => _ls.hasNewMed;

  void setState() {
    notifyListeners();
  }

  void setMedsLoaded(bool value) {
    _ls.medsLoaded = value;
    notifyListeners();
  }

  bool get isBusy => _ls.isBusy;
  void setBusy(bool loading) {
    _ls.isBusy = loading;
    _l.log(sectionName, 'Loading Data: $isBusy', linenumber: _l.lineNumber(StackTrace.current));
    notifyListeners();
  }

  Future<bool> getMedInfo() async {
    if (hasNewMed) {
      setBusy(true);
      bool gotMeds = await _ls.getMedInfo();
      setBusy(false);
      formKey.currentState.reset();
      notifyListeners();

      if (gotMeds) return true;
    }
    return false;
  }
}
