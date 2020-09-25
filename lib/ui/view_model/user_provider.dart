import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:medical_history/core/models/user_model.dart';
import 'package:medical_history/core/locator.dart';

class UserProvider with ChangeNotifier {
  final UserModel userModel = locator();

  UserProvider() {
    init();
  }

  String _name;
  bool _isLoggedIn;
  Timer loggedInTimer;
  int _secondsToLogout;

  bool get hasPermission => userModel.hasPermission;

  void requestPermission() {
    userModel.requestPermissions();
  }

  init() {
    _refreshAllStates();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get name => _name;

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
    _isLoggedIn = userModel.isLoggedIn();
    _name = userModel.getName();
    notifyListeners();
  }

  login(String userName) async {
    userName = userName.trim();
    userModel.login(userName);
    await _refreshAllStates();
  }

  logout() async {
    userModel.logout();
    _refreshAllStates();
  }

  @override
  void dispose() {
    loggedInTimer.cancel();
    super.dispose();
  }
}
