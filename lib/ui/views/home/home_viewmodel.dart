import 'package:flutter/material.dart';
import 'package:medical_history/core/constants.dart';
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
  bool runOnce = false;

  static const String records = kRecordsActivity;
  static const String doctors = kDoctorsActivity;
  static const String meds = kMedsActivity;

  HomeViewModel({UserProvider user}) {
    sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);
    _l.log(sectionName, 'Constructor executing', linenumber: _l.lineNumber(StackTrace.current));
    _user = user;
    _init();
  }

  void _init() async {
    iconTop = iconTopStart;
    iconLeft = iconLeftStart;
    iconRight = iconLeftStart;
    modelDirty(false);
    _doctorRepo.addListener(update);
  }

  bool isDisposed = false;

  @override
  void dispose() {
    _l.log(sectionName, 'Dispose was called', linenumber: _l.lineNumber(StackTrace.current));
    isDisposed = true;
    _doctorRepo.removeListener(update);
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////
  void reAnimate() {
    if (isDisposed) return;
    logoOpacity = 1.0;
    iconTop = {records: 0.30, doctors: 0.30, meds: 0.30, 'other': 0.30};
    iconLeft = {records: 0.35, doctors: 0.35, meds: 0.35, 'other': 0.35};
    iconRight = {records: 0.35, doctors: 0.35, meds: 0.35, 'other': 0.35};
    isLogoAnimating = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1)).then((value) => startAnimations());
  }

  //////////////////////////////////////////////////////////////////////
  void startAnimations() async {
    await animateLogo();
    await animateIcon(iconName: doctors);
    await animateIcon(iconName: records);
    await animateIcon(iconName: meds);
  }

  //////////////////////////////////////////////////////////////////////
  double logoOpacity = 1.0;
  bool isLogoAnimating = false;
  Future animateLogo() async {
    isLogoAnimating = true;
    await Future.delayed(Duration(milliseconds: 300));
    logoOpacity = 0.0;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 600));
    isLogoAnimating = false;
  }

  //////////////////////////////////////////////////////////////////////
  final Map iconTopStart = {records: 0.30, doctors: 0.30, meds: 0.30, 'other': 0.30};
  final Map iconTopEnd = {records: 0.10, doctors: 0.10, meds: 0.45, 'other': 0.00};
  Map iconTop;

  final Map iconLeftStart = {records: 0.35, doctors: 0.35, meds: 0.35, 'other': 0.35};
  final Map iconLeftEnd = {records: 0.08, doctors: 0.65, meds: 0.38, 'other': 0.10};
  Map iconLeft;
  Map iconRight;

  Future animateIcon({@required String iconName}) async {
    iconTop[iconName] = iconTopEnd[iconName];

    iconLeft[iconName] = iconLeftEnd[iconName];
    iconRight[iconName] = null;

    notifyListeners();
    await Future.delayed(Duration(milliseconds: 300));
  }

  String activityRoute(String activityName) {
    switch (activityName) {
      case kRecordsActivity:
        return historyRoute;
      case kMedsActivity:
        return medsRoute;
      case kDoctorsActivity:
        return doctorRoute;
    }
    return null;
  }

  String activityIcon(String activityName) {
    switch (activityName) {
      case kRecordsActivity:
        return "assets/medical-history.png";
      case kMedsActivity:
        return "assets/drug-2.png";
      case kDoctorsActivity:
        return "assets/doctor-1.png";
    }
    return null;
  }

  //////////////////////////////////////////////////////////////////////
  void update() => notifyListeners();

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
