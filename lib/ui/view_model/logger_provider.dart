import 'package:flutter/foundation.dart';
import 'package:medical_history/core/models/logger_model.dart';
import 'package:medical_history/core/locator.dart';

class LoggerProvider with ChangeNotifier {
  final LoggerModel _loggerModel = locator();

  bool get isInitialized => _loggerModel.prefs != null;

  bool isLogging(String sectionName) => _loggerModel.isEnabled(sectionName);

  void setOption(String sectionName, bool value) {
    _loggerModel.saveSetting(sectionName, value);
    notifyListeners();
  }
}
