import 'package:flutter/material.dart';
import 'package:medical_history/ui/themes/theme_dark.dart';
import 'package:medical_history/ui/themes/theme_light.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeDataProvider with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences prefs;
  bool isInitialized;
  bool _useDarkTheme;
  double _appMargin;
  int _animationDuration = 200;

  ThemeDataProvider() {
    isInitialized = false;
    _initialize();
    _appMargin = 0.0;
    _useDarkTheme = false;
  }

  ThemeData get themeData => _useDarkTheme ? myThemeDark : myThemeLight;

  bool get isDarkTheme => _useDarkTheme;
  double get appMargin => _appMargin;
  int get animDuration => _animationDuration;

  ///
  /// Set the application working margin.
  ///
  void setAppMargin(double appMargin) {
    _appMargin = appMargin;
  }

  void toggleTheme() {
    _useDarkTheme = !_useDarkTheme;
    _savePrefs();
    notifyListeners();
  }

  Future _loadPrefs() async {
    prefs = await _prefs;
    _useDarkTheme = prefs.getBool("useDarkMode") ?? true;
    notifyListeners();
  }

  void _savePrefs() async {
    prefs = await _prefs;
    prefs.setBool("useDarkMode", _useDarkTheme);
  }

  void _initialize() async {
    prefs = await _prefs;
    await _loadPrefs();
    isInitialized = true;
  }
}
