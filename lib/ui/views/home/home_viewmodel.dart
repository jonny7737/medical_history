import 'package:flutter/material.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/doctor_data_service.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_data_service.dart';
import 'package:medical_history/ui/view_model/user_provider.dart';

class HomeViewModel with ChangeNotifier {
  final DoctorDataService _doctorRepo = locator();
  final MedDataService _medRepo = locator();
  final Logger _l = locator();

  String sectionName;
  UserProvider _user;

  HomeViewModel({UserProvider user}) {
    sectionName = this.runtimeType.toString();
    _user = user;
    _l.initSectionPref(sectionName);
    _init();
  }
  void _init() async {
    modelDirty(false);
    _doctorRepo.addListener(update);
  }

  void update() => notifyListeners();

  bool isDisposed = false;

  @override
  void dispose() {
    _l.log(sectionName, 'Dispose was called', linenumber: _l.lineNumber(StackTrace.current));
    isDisposed = true;
    _doctorRepo.removeListener(update);
    super.dispose();
  }

  bool _modelDirty = false;
  bool get isModelDirty => _modelDirty;
  void modelDirty(bool value) {
    bool oldDirtyState = isModelDirty;
    _modelDirty = value;
    _l.log(
      sectionName,
      'Model Dirty: $isModelDirty <= $oldDirtyState',
      linenumber: _l.lineNumber(StackTrace.current),
    );
    update();
  }

  String get userName => _user?.name;

  get numberOfDoctors => _doctorRepo.numberOfDoctors;

  String _errorMsg = 'Please add at least one Doctor';
  double _errorMsgMaxHeight = 35;
  double _addMedErrorMsgHeight = 0;

  double get errorMsgHeight => _addMedErrorMsgHeight;
  String get errorMsg => _errorMsg;

  void showAddMedError() {
    if (_addMedErrorMsgHeight > 0) return;
    _setAddMedErrorHeight(_errorMsgMaxHeight);
    Future.delayed(Duration(seconds: 4), () {
      if (isDisposed) return;
      _setAddMedErrorHeight(0);
    });
  }

  void _setAddMedErrorHeight(double height) {
    _addMedErrorMsgHeight = height;
    notifyListeners();
  }

  void clearListData() {
    _doctorRepo.clearAllDoctors();
    _medRepo.clearAllMeds();
  }
}
