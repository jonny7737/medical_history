import 'package:get_it/get_it.dart';
import 'package:medical_history/core/models/logger_model.dart';
import 'package:medical_history/core/models/user_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<LoggerModel>(LoggerModel());
  locator.registerSingleton<UserModel>(UserModel(), signalsReady: false);

  print('locator setup complete');
}
