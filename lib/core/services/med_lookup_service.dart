import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/helpers/med_request.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/models/temp_med.dart';
import 'package:medical_history/core/services/repository_service.dart';
import 'package:medical_history/ui/view_model/user_provider.dart';

class MedLookUpService with ChangeNotifier {
  final container = ProviderContainer();
  UserProvider _user;
  final Logger _l = locator();
  final String sectionName = 'MedLookUpService';

  MedLookUpService() {
    _user = container.read(userProvider);
  }

  bool isBusy = false;
  bool medsLoaded = false;
  bool wasMedAdded = false;
  int numMedsFound = 0;
  String rxcuiComment;
  TempMed tempMed;
  MedData _selectedMed;

  int editIndex;

  String newMedName;
  String newMedDose;
  String newMedFrequency;
  String newMedDoctorName;
  int newMedDoctorId;

  TempMed get medFound => tempMed;
  MedData get selectedMed => _selectedMed;

  void setBusy(bool b) => isBusy = b;

  bool get hasNewMed {
    _l.log(sectionName, '$newMedName : $newMedDose', linenumber: _l.lineNumber(StackTrace.current));

    if (newMedName == null || newMedDose == null || newMedFrequency == null) return false;
    if (newMedName.length > 2 && newMedDose.length > 2 && newMedFrequency.length > 3) return true;
    return false;
  }

  void saveMed(MedData _medData) {
    RepositoryService repository = locator();
    repository.save(_medData);
    wasMedAdded = true;
    clearNewMed();
    notifyListeners();
  }

  void saveSelectedMed(int index) {
    _selectedMed = MedData(
      _user.name,
      editIndex,
      tempMed.rxcui,
      tempMed.imageInfo.names[index],
      tempMed.imageInfo.mfgs[index],
      tempMed.imageInfo.urls[index],
      tempMed.info,
      tempMed.warnings,
      doctorId: newMedDoctorId,
      dose: newMedDose,
      frequency: newMedFrequency,
    );
    saveMed(_selectedMed);
  }

  Future saveMedNoMfg() async {
    _selectedMed = MedData(
      _user.name,
      editIndex,
      tempMed.rxcui,
      tempMed.imageInfo.names[0],
      'Unknown Manufacture',
      null,
      tempMed.info,
      tempMed.warnings,
      doctorId: newMedDoctorId,
      dose: newMedDose,
      frequency: newMedFrequency,
    );

    /// All of this just to copy the 'Unknown  Manufacturer' image to the medImages directory.
    ///
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = p.join(directory.path, 'medImages/${tempMed.rxcui}.jpg');
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load('assets/drug.jpg');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }

    saveMed(_selectedMed);
  }

  void clearTempMeds() {
    medsLoaded = false;
    numMedsFound = 0;
    rxcuiComment = null;
    tempMed = null;
    _l.log(sectionName, 'Temp Meds cleared.', linenumber: _l.lineNumber(StackTrace.current));
    notifyListeners();
  }

  void clearNewMed() {
    isBusy = false;
    medsLoaded = false;
    editIndex = null;
    newMedName = null;
    newMedDose = null;
    newMedFrequency = null;
    newMedDoctorName = null;
    newMedDoctorId = null;
    notifyListeners();
    _l.log(sectionName, 'New Med Info cleared.', linenumber: _l.lineNumber(StackTrace.current));
  }

  Future<bool> getMedInfo() async {
    if (hasNewMed) {
      medsLoaded = false;
      _selectedMed = null;
      setBusy(true);
      MedRequest _medRequest = MedRequest();
      bool gotMeds = await _medRequest.medInfoByName('$newMedName $newMedDose oral');
      setBusy(false);

      rxcuiComment = _medRequest.rxcuiComment;

      if (!gotMeds) return false;

      _l.log(
        sectionName,
        'MedRequest meds loaded: ${_medRequest.numMeds} '
        '[${_medRequest.med(0).isValid()}]',
        linenumber: _l.lineNumber(StackTrace.current),
      );
      if (_medRequest.imageURLs.length > 0) {
        tempMed = _medRequest.meds[0];
        medsLoaded = true;
        numMedsFound = tempMed.imageInfo.urls.length;
        return true;
      }
    }
    return false;
  }
}
