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
  bool runOnce = false;

  HomeViewModel({UserProvider user}) {
    // _l.log(sectionName, 'Constructor executing', linenumber: _l.lineNumber(StackTrace.current));
    print('Constructor executing');
    sectionName = this.runtimeType.toString();
    _user = user;
    _l.initSectionPref(sectionName);
    _init();
  }

  void _init() async {
    modelDirty(false);
    _doctorRepo.addListener(update);
  }

  //////////////////////////////////////////////////////////////////////
  void startAnimations() async {
    await Future.delayed(Duration(milliseconds: 500));
    logoOpacity = 1.0;
    await animateLogo();
    await animateIcon('records', 1, 1);
    await animateIcon('doctors', 1, -1);
  }

  //////////////////////////////////////////////////////////////////////
  double logoOpacity = 1.0;
  Future animateLogo() async {
    await Future.delayed(Duration(seconds: 1));
    logoOpacity = 0.0;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 600));
  }

  //////////////////////////////////////////////////////////////////////
  Map<String, double> iconTopStart = {
    'records': 0.40,
    'doctors': 0.40,
    'meds': 0.40,
    'other': 0.40,
  };
  Map<String, double> iconTopEnd = {
    'records': 0.10,
    'doctors': 0.10,
    'meds': 0.70,
    'other': 0.70,
  };
  Map<String, double> iconTop = {'records': 0.40, 'doctors': 0.40, 'meds': 0.40, 'other': 0.40};

  Map<String, double> iconLeftStart = {
    'records': 0.40,
    'doctors': 0.40,
    'meds': 0.40,
    'other': 0.40,
  };
  Map<String, double> iconLeftEnd = {
    'records': 0.10,
    'doctors': 0.10,
    'meds': 0.10,
    'other': 0.10,
  };
  Map<String, double> iconLeft = {'records': 0.40, 'doctors': 0.40, 'meds': 0.50, 'other': 0.50};
  Map<String, double> iconRight = {'records': 0.40, 'doctors': 0.40, 'meds': 0.50, 'other': 0.50};

  Future animateIcon(String iconName, int topOffset, int leftOffset) async {
    await Future.delayed(Duration(milliseconds: 400));
    iconTop[iconName] = iconTopEnd[iconName];
    if (leftOffset > 0)
      iconLeft[iconName] = iconLeftEnd[iconName];
    else
      iconLeft[iconName] = null;

    if (leftOffset < 0)
      iconRight[iconName] = iconLeftEnd[iconName];
    else
      iconRight[iconName] = null;

    await Future.delayed(Duration(milliseconds: 600));
    notifyListeners();
  }

  //////////////////////////////////////////////////////////////////////
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
