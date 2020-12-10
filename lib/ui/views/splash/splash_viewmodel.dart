import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/secure_storage.dart';
import 'package:medical_history/ui/view_model/user_provider.dart';

class SplashViewModel {
  final Logger _l = locator();
  final SecureStorage _ss = locator();
  final container = ProviderContainer();

  SplashViewModel() {
    user = container.read(userProvider);
    hasPermission = user.requestPermission();
    // print('SplashViewModel constructor complete');
  }

  Future<bool> hasPermission;
  UserProvider user;

  void nextStep(BuildContext context, String sectionName) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (context == null) return;
    // print('--$context');

    if (!await _ss.doctorBoxKeySet) {
      _l.log(sectionName, 'Executing KeyGen Route', always: false);
      Navigator.pushNamed(context, keygenRoute).then((value) {
        _l.log(sectionName, 'Executing Login Route', always: false);
        Navigator.pushReplacementNamed(context, loginRoute);
      });
    } else if (user.shouldLogin) {
      _l.log(sectionName, 'Executing Login Route', always: false);
      Navigator.pushReplacementNamed(context, loginRoute);
    } else {
      _l.log(sectionName, 'Executing Home Route', linenumber: _l.lineNumber(StackTrace.current));
      Navigator.pushReplacementNamed(context, homeRoute);
    }
  }
}
