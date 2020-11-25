import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  SharedPreferences prefs;
  bool _allowWriteFile = false;

  UserModel() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool get hasPermission => _allowWriteFile;

  Future<bool> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      _allowWriteFile = true;
      return true;
    } else
      //  Permission denied.
      return false;
  }

  static const String _IS_LOGGED_IN = "is_logged_in";
  static const String _NAME = "name";
  static const String _EXPIRE = "expire";
  static const String _LOGIN_AT = "login_at";

  int get loggedInAt => prefs?.getInt(_LOGIN_AT);

  int secondsToLogout() {
    var expirey = prefs?.getInt(_EXPIRE);
    if (expirey == null) {
      return -1;
    } else {
      return (expirey - DateTime.now().millisecondsSinceEpoch ~/ 1000);
    }
  }

  void logout() {
    if (!_allowWriteFile || prefs == null) return;
    prefs.remove(_IS_LOGGED_IN);
    prefs.remove(_NAME);
    prefs.remove(_EXPIRE);
    prefs.remove(_LOGIN_AT);
  }

  bool login(String name) {
    if (!_allowWriteFile || prefs == null) return false;
    if (isLoggedIn() == true) {
      return true;
    }
    var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    /**
     * Require login at least once per day
     */
    var xp = now + (24 * 60 * 60);
    prefs.setBool(_IS_LOGGED_IN, true);
    prefs.setString(_NAME, name);
    prefs.setInt(_EXPIRE, xp);
    prefs.setInt(_LOGIN_AT, now);
    return true;
  }

  bool isLoggedIn() {
    if (!_allowWriteFile || prefs == null) init();
    var expirey = prefs?.getInt(_EXPIRE);
    if (expirey == null) {
      logout();
      return false;
    } else if (expirey < DateTime.now().millisecondsSinceEpoch ~/ 1000) {
      logout();
      return false;
    }
    return prefs?.containsKey(_IS_LOGGED_IN);
  }

  String getName() {
    return prefs?.getString(_NAME);
  }
}
