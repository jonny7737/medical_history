import 'package:flutter/material.dart';
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

  // ThemeData get themeData => isDarkTheme ? myThemeDark : myThemeLight;
  ThemeData get themeData => ThemeData(
        primarySwatch: isDarkTheme
            ? MaterialColor(4280361249, {
                50: Color(0xfff2f2f2),
                100: Color(0xffe6e6e6),
                200: Color(0xffcccccc),
                300: Color(0xffb3b3b3),
                400: Color(0xff999999),
                500: Color(0xff808080),
                600: Color(0xff666666),
                700: Color(0xff4d4d4d),
                800: Color(0xff333333),
                900: Color(0xff191919)
              })
            : MaterialColor(4280310527, {
                50: Color(0xffe5ecff),
                100: Color(0xffccd9ff),
                200: Color(0xff99b4ff),
                300: Color(0xff668eff),
                400: Color(0xff3368ff),
                500: Color(0xff0042ff),
                600: Color(0xff0035cc),
                700: Color(0xff002899),
                800: Color(0xff001b66),
                900: Color(0xff000d33)
              }),
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        primaryColor: isDarkTheme ? Color(0xff212121) : Color(0xff205aff),
        primaryColorBrightness: Brightness.dark,
        scaffoldBackgroundColor: isDarkTheme ? Colors.yellow[700] : Colors.yellow[500],
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: isDarkTheme ? Colors.white : Colors.black,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: isDarkTheme ? Colors.black87 : Color(0xff205aff),
          elevation: 8.0,
          actionsIconTheme:
              isDarkTheme ? IconThemeData(color: Colors.white) : IconThemeData(color: Colors.black),
        ),
        cardTheme: CardTheme(
          color: isDarkTheme ? Color(0xFAFFFFFF) : Color(0xEAFFFFFF),
          elevation: 40,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(40, 60),
              bottomRight: Radius.elliptical(40, 60),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xdd000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          helperStyle: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xdd000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          hintStyle: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xdd000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          errorStyle: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xdd000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          errorMaxLines: null,
          isDense: false,
          contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
          isCollapsed: false,
          prefixStyle: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xdd000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          suffixStyle: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xdd000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          counterStyle: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xdd000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          filled: false,
          fillColor: Color(0x00000000),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      );

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
