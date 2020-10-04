import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sized_context/sized_context.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/doctor_data_service.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_data_service.dart';
import 'package:medical_history/ui/view_model/user_provider.dart';

class MedsViewModel with ChangeNotifier {
  final Logger _l = locator();
  final MedDataService _medDataService = locator();
  final DoctorDataService _doctorDataService = locator();

  UserProvider _user;
  String sectionName;

  MedsViewModel({UserProvider user}) {
    sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);
    _user = user;
    _init();
    _l.log(sectionName, 'Constructor complete');
  }

  void _init() async {
    _user.addListener(update);
    await _setImageDirectory();
    updateListData();
    _medDataService.addListener(updateListData);
    _doctorDataService.addListener(updateListData);
  }

  void update() {
    modelDirty(true);
  }

  bool isDisposed = false;

  @override
  void dispose() {
    _l.log(sectionName, 'Dispose was called', linenumber: _l.lineNumber(StackTrace.current));
    isDisposed = true;
    _user.removeListener(update);
    _medDataService.removeListener(updateListData);
    _doctorDataService.removeListener(updateListData);
    super.dispose();
  }

  String get userName => _user.name;

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
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////////////////////////
  bool _bottomSet = false;
  double _bottomCardUp = 0;
  double _bottomCardDn = 0;
  bool _detailCardVisible = false;

  int activeMedIndex;
  String imageDirectoryPath;

  void setActiveMedIndex(int ndx) {
    activeMedIndex = ndx;
  }

  MedData get activeMed {
    if (activeMedIndex == null) {
      return mtMedData;
    } else {
      _l.log(sectionName, 'activeMedIndex = $activeMedIndex',
          linenumber: _l.lineNumber(StackTrace.current));
      MedData md = _medDataService.getMedAtIndex(activeMedIndex);
      if (md == null) {
        setActiveMedIndex(null);
        return mtMedData;
      }
      return md;
    }
  }

  File get activeImageFile => imageFile(activeMed.rxcui);

  Future _setImageDirectory() async {
    Directory imageDirectory = await getApplicationDocumentsDirectory();
    Directory subDir = await Directory('${imageDirectory.path}/medImages').create(recursive: true);
    imageDirectoryPath = subDir.path;
  }

  File _file(String filename) {
    String pathName = p.join(imageDirectoryPath, filename);
    return File(pathName);
  }

  File imageFile(String rxcui) {
    //   if (rxcui == '00000') return null;

    List<MedData> _meds = _medDataService.getAllMeds();
    int ndx = _meds.indexWhere((element) => element.rxcui == rxcui);

    if (ndx == -1 || imageDirectoryPath == null) return null;
    File file = _file('$rxcui.jpg');
    return file;
  }

  setDefaultMedImage(String rxcui) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var iPath = p.join(directory.path, 'medImages/$rxcui.jpg');
    if (FileSystemEntity.typeSync(iPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load('assets/drug.jpg');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(iPath).writeAsBytes(bytes);
      _l.log(sectionName, 'Default image set: $iPath',
          linenumber: _l.lineNumber(StackTrace.current));
    }
  }

  bool get bottomsSet => _bottomSet;
  void setBottoms(BuildContext context) {
    if (_bottomSet) return;
    _bottomCardUp = context.heightPct(0.14);
    _bottomCardDn = -(context.heightPct(1.0) + context.heightPct(0.14));
    _bottomSet = true;
  }

  double get cardBottom {
    if (_detailCardVisible)
      return _bottomCardUp;
    else
      return _bottomCardDn;
  }

  bool get detailCardVisible => _detailCardVisible;

  void showDetailCard() {
    _l.log(sectionName, 'Detail Card UP');
    _detailCardVisible = true;
    notifyListeners();
  }

  void hideDetailCard() {
    _l.log(sectionName, 'Detail Card DN');
    _detailCardVisible = false;
    notifyListeners();
  }

  int get numberOfDoctors => _doctorDataService.numberOfDoctors;

  int get numberOfMeds => _medDataService.numberOfMeds;

  List<MedData> get medList => _medDataService.getAllMeds();

  List<DoctorData> get doctorList => _doctorDataService.getAllDoctors();

  int get size => _medDataService.numberOfMeds;

  MedData get mtMedData =>
      MedData(_user.name, -1, '00000', 'MT MedData', '', '', [], [], doctorId: -1);

  void updateListData() async {
    _l.log(sectionName, 'Updating lists', linenumber: _l.lineNumber(StackTrace.current));
    modelDirty(false);
  }

  void clearListData() async {
    await _medDataService.clearAllMeds();
    _l.log(sectionName, 'Only One User: ${_medDataService.onlyOneUser}',
        linenumber: _l.lineNumber(StackTrace.current));
    if (_medDataService.onlyOneUser) await _doctorDataService.clearAllDoctors();
    modelDirty(true);
  }

  DoctorData getDoctorById(int id) {
    List<DoctorData> _doctors = _doctorDataService.getAllDoctors();
    int ndx = _doctors.indexWhere((element) => id == element.id);
    if (ndx == -1) {
      ndx = 0;
      //return DoctorData(id, 'Doctor not configured', '');
    } //else
    return _doctors[ndx];
  }

  void save(Object newObject) async {
    await _medDataService.save(newObject);
    notifyListeners();
  }

  MedData getMedByRxcui(String rxcui) {
    return _medDataService.getMedByRxcui(rxcui);
  }

  MedData getMedAt(int index) {
    return _medDataService.getMedAtIndex(index);
  }

  void delete(Object objectToDelete) async {
    await _medDataService.delete(objectToDelete);

    if (objectToDelete is DoctorData) return;

    final dir = Directory(imageDirectoryPath);
    if (dir.existsSync()) {
      var files = dir.listSync().toList();
      for (var i in files) {
        String _rxcui = p.basename(i.path).split(".")[0];
        if (getMedByRxcui(_rxcui) == null) {
          _l.log(sectionName, 'Deleting: ${i.path}', linenumber: _l.lineNumber(StackTrace.current));
          File(i.path).deleteSync();
          _l.log(sectionName, 'Deleted: $_rxcui', linenumber: _l.lineNumber(StackTrace.current));
        }
      }
    }
  }
}
