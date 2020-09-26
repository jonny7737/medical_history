import 'package:get_it/get_it.dart';
import 'package:medical_history/core/models/logger_model.dart';
import 'package:medical_history/core/models/user_model.dart';
import 'package:medical_history/core/services/doctor_data_box.dart';
import 'package:medical_history/core/services/doctor_data_repository.dart';
import 'package:medical_history/core/services/doctor_data_service.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_data_box.dart';
import 'package:medical_history/core/services/med_data_repository.dart';
import 'package:medical_history/core/services/med_data_service.dart';
import 'package:medical_history/core/services/secure_storage.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/doctors/doctors_viewmodel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /// Order is significant.  This may break later.
  /// TODO: Learn how to synchronize GetIt startup
  locator.registerSingleton<LoggerModel>(LoggerModel());
  locator.registerSingleton<Logger>(Logger());
  locator.registerSingleton<SecureStorage>(SecureStorage());
  locator.registerSingleton<UserModel>(UserModel(), signalsReady: false);
  locator.registerSingleton<ScreenInfoViewModel>(ScreenInfoViewModel());

  locator.registerLazySingleton<DoctorsViewModel>(() => DoctorsViewModel());

  // locator.registerLazySingleton<RepositoryService>(() => DataService());
  locator.registerLazySingleton<DoctorDataService>(() => DoctorDataService());
  locator.registerLazySingleton<MedDataService>(() => MedDataService());
  locator.registerLazySingleton<MedDataRepository>(() => MedDataRepository());
  locator.registerLazySingleton<DoctorDataRepository>(() => DoctorDataRepository());

  locator.registerLazySingleton<MedDataBox>(() => MedDataBox());
  locator.registerLazySingleton<DoctorDataBox>(() => DoctorDataBox());
}
