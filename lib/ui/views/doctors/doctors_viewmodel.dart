import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/core/global_providers.dart';

import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/helpers/misc_utils.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/services/doctor_data_service.dart';

class DoctorsViewModel with ChangeNotifier {
  DoctorDataService _repository = locator();

  final container = ProviderContainer();
  final Logger _l = locator();
  String sectionName;

  DoctorsViewModel() {
    sectionName = this.runtimeType.toString();
    _repository.addListener(updateDoctors);
    _l.initSectionPref(sectionName);
    _l.log(sectionName, 'DoctorViewModel instantiated.');
    setModelDirty(dirty: true);
  }

  void updateDoctors() {
    notifyListeners();
    _l.log(sectionName, 'Message received from Repository',
        linenumber: _l.lineNumber(StackTrace.current));
  }

  ////////////////////////////////////////////////////////////////////////////
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    _repository.removeListener(updateDoctors);
    super.dispose();
  }

  ////////////////////////////////////////////////////////////////////////////
  double _errorMsgMaxHeight = 35;
  String _doctorNameErrorMsg = 'Doctor\'s name is required.';
  String _doctorPhoneErrorMsg = 'Doctor\'s phone number is required.';
  String _doctorExistsErrorMsg = 'Already in the list.';
  double _doctorNameErrorMsgHeight = 0;
  double _doctorPhoneErrorMsgHeight = 0;
  double _doctorExistsErrorMsgHeight = 0;
  Duration _secondsToDisplayErrorMsg = Duration(seconds: 4);

  double get nameErrorMsgHeight => _doctorNameErrorMsgHeight;
  double get phoneErrorMsgHeight => _doctorPhoneErrorMsgHeight;
  double get existsErrorMsgHeight => _doctorExistsErrorMsgHeight;
  String get nameErrorMsg => _doctorNameErrorMsg;
  String get phoneErrorMsg => _doctorPhoneErrorMsg;
  String get existsErrorMsg => _doctorExistsErrorMsg;

  void onFormSave(String formField, String value) {
    if (value == null || value.isEmpty || (formField == 'phone' && value.length != 14)) {
      showError(formField);
      setFormError(true);
    } else {
      setFormError(false);
      if (formField == 'name') setDoctorName(capitalizeWords(value));
      if (formField == 'phone') setDoctorPhone(value);
    }
  }

  double errorMsgHeight(String error) {
    if (error == 'name') return nameErrorMsgHeight;
    if (error == 'phone') return phoneErrorMsgHeight;
    if (error == 'already_exists') return existsErrorMsgHeight;
    return 100.0;
  }

  String errorMsg(String error) {
    if (error == 'name') return nameErrorMsg;
    if (error == 'phone') return phoneErrorMsg;
    if (error == 'already_exists') return existsErrorMsg;
    return 'Unknown ERROR';
  }

  int _formErrors = 0;

  bool get formHasErrors {
    if (_formErrors != 0) return true;
    return false;
  }

  void setFormError(bool errors) {
    errors ? _formErrors++ : _formErrors--;
    if (_formErrors < 0) _formErrors = 0;
  }

  void clearFormError() {
    _l.log(sectionName, '$_newDoctorName : $_newDoctorPhone',
        linenumber: _l.lineNumber(StackTrace.current));
    _formErrors = 0;
  }

  void showError(String error) {
    _l.log(sectionName, '$error requested', linenumber: _l.lineNumber(StackTrace.current));
    _setErrorHeight(error: error, height: _errorMsgMaxHeight);
    Future.delayed(
      _secondsToDisplayErrorMsg,
      () => {_setErrorHeight(error: error, height: 0)},
    );
  }

  void _setErrorHeight({String error, double height}) {
    if (_isDisposed) {
      _l.log(sectionName, 'DoctorViewModel was disposed');
      return;
    }
    if (error == 'name') _doctorNameErrorMsgHeight = height;
    if (error == 'phone') _doctorPhoneErrorMsgHeight = height;
    if (error == 'already_exists') _doctorExistsErrorMsgHeight = height;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////
  bool _busy = false;
  bool _modelDirty = false;
  bool _doctorAdded = false;
  int _activeDoctor = -1;
//  List<DoctorData> _listOfDoctors;

  String _newDoctorName;
  String _newDoctorPhone;
  bool get hasNewDoctor {
    _l.log(sectionName, '$_newDoctorName : $_newDoctorPhone',
        linenumber: _l.lineNumber(StackTrace.current));
    if (_newDoctorName == null || _newDoctorPhone == null) return false;
    if (_newDoctorName.length >= 3 && _newDoctorPhone.length == 14) return true;
    return false;
  }

  int get numberOfDoctors => _repository.numberOfDoctors;

  List<DoctorData> get doctors => _repository.getAllDoctors();
  DoctorData doctorByIndex(int index) => _repository.getAllDoctors()[index];

  DoctorData getDoctorByName(String name) => _repository.getDoctorByName(name);

  bool get addedDoctors => _doctorAdded;

  int get activeDoctor => _activeDoctor;
  void setActiveDoctor(int index) => _activeDoctor = index;
  DoctorData get activeDoctorData {
    if (_activeDoctor == -1) return null;
    if (_repository.getAllDoctors().isEmpty) {
      _activeDoctor = -1;
      return null;
    }
    return _repository.getAllDoctors()[_activeDoctor];
  }

  String get activeDoctorName {
    if (_activeDoctor == -1) return null;
    if (_repository.getAllDoctors().isEmpty) {
      _activeDoctor = -1;
      return null;
    }
    return activeDoctorData.name;
  }

  String get activeDoctorPhone {
    if (_activeDoctor == -1) return null;
    if (_repository.getAllDoctors().isEmpty) {
      _activeDoctor = -1;
      return null;
    }
    return activeDoctorData.phone;
  }

  bool get isBusy => _busy;
  void setBusy(bool b) => _busy = b;

  bool get isModelDirty => _modelDirty;
  void setModelDirty({bool dirty}) {
    _modelDirty = dirty;
    _l.log(sectionName, 'Model dirty:$_modelDirty', linenumber: _l.lineNumber(StackTrace.current));
    notifyListeners();
  }

  void setDoctorName(String value) => _newDoctorName = value.trim();
  void setDoctorPhone(String value) => _newDoctorPhone = value.trim();
  void clearNewDoctor() {
    _newDoctorName = null;
    _newDoctorPhone = null;
    _doctorAdded = false;
    _activeDoctor = -1;
  }

  void deleteDoctor(int index) async {
    await _repository.delete(doctorByIndex(index));
    _l.log(sectionName, 'Deleting Doctor: ${doctorByIndex(index).name}');
  }

  void saveDoctor() async {
    final String name = container.read(userProvider).name;
    int id = _activeDoctor;

    DoctorData _doctor =
        DoctorData(id: id, owner: name, name: _newDoctorName, phone: _newDoctorPhone);
    await _repository.save(_doctor);
    setActiveDoctor(-1);
    _doctorAdded = true;
    setModelDirty(dirty: true);
  }
}
