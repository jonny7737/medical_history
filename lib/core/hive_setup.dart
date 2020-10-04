import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/logger.dart';

class HiveSetup {
  final Logger _l = locator();
  final String sectionName = 'HiveSetup';

  HiveSetup({bool purge = false}) {
    _l.initSectionPref(sectionName);
    _l.log(sectionName, 'HiveSetup started [PURGE REQUIRED: $purge');

    _initializeHive(purge: purge);
  }

  void _initializeHive({bool purge = false}) async {
    _l.log(sectionName, 'Initializing Hive, Purge All Data: $purge');
    await Hive.initFlutter(kHiveDirectory);

    Hive.registerAdapter(MedDataAdapter());
    Hive.registerAdapter(DoctorDataAdapter());

    if (purge) {
      Future.wait([
        Hive.deleteBoxFromDisk(kMedHiveBox),
        Hive.deleteBoxFromDisk(kDoctorHiveBox),
      ]);
      _initializeFakeData();
    }
    _l.log(sectionName, 'HiveSetup complete');
  }

  Future _initializeFakeData() async {
    // RepositoryService repository = locator();
    // await repository.initializeMedData();
    // await repository.initializeDoctorData();
  }
}
