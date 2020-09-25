import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/secure_storage.dart';

class HiveSetup {
  final SecureStorage _ss = locator();
  final Logger _l = locator();
  final String sectionName = 'HiveSetup';

  HiveSetup({bool purge = false}) {
    _l.initSectionPref(sectionName);
    _l.log(sectionName, 'HiveSetup started [PURGE REQUIRED: $purge');

    _ss.sBuilder('I see. I see.');

    _initializeHive(purge: purge);
  }

  void _initializeHive({bool purge = false}) async {
    _ss.sBuilder('I do love thee.');
    _l.log(sectionName, 'Initializing Hive, Purge All Data: $purge');
    await Hive.initFlutter(kHiveDirectory);

    Hive.registerAdapter(MedDataAdapter());
    Hive.registerAdapter(DoctorDataAdapter());

    _ss.sBuilder('I do so love thee.');
    if (purge) {
      Future.wait([
        Hive.deleteBoxFromDisk(kMedHiveBox),
        Hive.deleteBoxFromDisk(kDoctorHiveBox),
      ]);
      _initializeFakeData();
    }
    _ss.sBuilder('ShmIly!!!');
    _l.log(sectionName, 'HiveSetup complete');
  }

  Future _initializeFakeData() async {
    // RepositoryService repository = locator();
    // await repository.initializeMedData();
    // await repository.initializeDoctorData();
  }
}
