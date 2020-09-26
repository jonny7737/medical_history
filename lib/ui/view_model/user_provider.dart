import 'package:flutter/foundation.dart';
import 'package:medical_history/core/models/user_model.dart';
import 'package:medical_history/core/locator.dart';

class UserProvider with ChangeNotifier {
  final UserModel userModel = locator();

  UserProvider() {
    init();
  }

  int _secondsToLogout;

  bool get hasPermission => userModel.hasPermission;

  void requestPermission() {
    userModel.requestPermissions();
  }

  init() {
    _refreshAllStates();
  }

  bool get isLoggedIn => userModel.isLoggedIn();
  String get name => userModel.getName();

  int get logoutTime {
    if (userModel.secondsToLogout() != _secondsToLogout) {
      _secondsToLogout = userModel.secondsToLogout();
    }
    return _secondsToLogout;
  }

  bool get shouldLogin {
    if (!userModel.hasPermission) return true;
    if (logoutTime > 0) {
      return false;
    }
    return true;
  }

  _refreshAllStates() {
    notifyListeners();
  }

  login(String userName) {
    userModel.login(userName.trim());
    _refreshAllStates();
  }

  logout() {
    userModel.logout();
    _refreshAllStates();
  }
}
