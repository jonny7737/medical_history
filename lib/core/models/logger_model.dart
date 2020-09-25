import 'package:shared_preferences/shared_preferences.dart';

class LoggerModel {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  LoggerModel() {
    init();
  }

  void init() async {
    prefs = await _prefs;
  }

  void runLater(String sectionName) async {
    _prefs.then((SharedPreferences prefs) {
      if (prefs.containsKey('MH-' + sectionName)) return;
      prefs.setBool('MH-' + sectionName, false);
    });
  }

  List<String> allKeys() {
    List<String> keyList = [];
    var keys = prefs.getKeys().toList();
    for (var key in keys) {
      if (key.startsWith('MH-')) {
        keyList.add(key.split('-')[1]);
      }
    }
    return keyList;
  }

  void initSectionPref(String sectionName) async {
    if (prefs == null) {
      runLater(sectionName);
      return;
    }
    if (prefs.containsKey('MH-' + sectionName)) return;
    prefs.setBool('MH-' + sectionName, false);
    return;
  }

  void removeSection(String sectionName) => prefs.remove('MH-' + sectionName);

  bool isEnabled(String sectionName) {
    sectionName = 'MH-' + sectionName;
    bool enabled = prefs?.getBool(sectionName);
    return enabled ?? false;
  }

  void saveSetting(String sectionName, bool value) {
    sectionName = 'MH-' + sectionName;
    prefs.setBool(sectionName, value);
    return;
  }

  void saveAllSettings(Map<String, bool> settings) {
    if (prefs == null) return;
    settings.forEach((k, v) async {
      prefs.setBool(k, v);
      return;
    });
  }
}
