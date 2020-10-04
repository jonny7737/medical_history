import 'package:flutter/foundation.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/logger_model.dart';

class LoggerProvider with ChangeNotifier {
  final LoggerModel _loggerModel = locator();

  List<String> listOfSectionNames() {
    return _loggerModel.allKeys();
  }

  void initSection(String sectionName) {
    return _loggerModel.initSectionPref(sectionName);
  }

  void removeSection(String sectionName) {
    _loggerModel.removeSection(sectionName);
    notifyListeners();
  }

  bool get isInitialized => _loggerModel.prefs != null;

  bool isLogging(String sectionName) => _loggerModel.isEnabled(sectionName);

  void setOption(String sectionName, bool value) {
    _loggerModel.saveSetting(sectionName, value);
    notifyListeners();
  }
}
