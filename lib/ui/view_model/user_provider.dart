import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:medical_history/core/mixins/logger.dart';
import 'package:medical_history/core/models/user_model.dart';
import 'package:medical_history/core/locator.dart';

class UserProvider with ChangeNotifier, Logger {
  final UserModel userModel = locator();

  UserProvider() {
    setLogging(true);
    init();
  }

  String _name;
  bool _isLoggedIn;
  Timer loggedInTimer;
  int _secondsToLogout;

  init() async {
    await _refreshAllStates();
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
    if (logoutTime > 0) {
      return false;
    }
    return true;
  }

  _refreshAllStates() async {
    _isLoggedIn = await userModel.isLoggedIn();
    _name = await userModel.getName();
    notifyListeners();
  }

  login(String userName) async {
    userName = userName.trim();
    await userModel.login(userName);
    await _refreshAllStates();
  }

  logout() async {
    await userModel.logout();
    await _refreshAllStates();
  }

  @override
  void dispose() {
    loggedInTimer.cancel();
    super.dispose();
  }
}
