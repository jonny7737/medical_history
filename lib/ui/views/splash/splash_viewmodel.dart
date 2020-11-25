import 'package:flutter/material.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/secure_storage.dart';

class SplashViewModel {
  final Logger _l = locator();
  final SecureStorage _ss = locator();

  void runLater(
      BuildContext context, String sectionName, bool hasPermission, bool shouldLogin) async {
    await Future.delayed(Duration(seconds: 1));

    if (context == null) return;

    if (!await _ss.doctorBoxKeySet) {
      _l.log(sectionName, 'Executing KeyGen Route', always: false);
      Navigator.pushNamed(context, keygenRoute).then((value) {
        _l.log(sectionName, 'Executing Login Route', always: false);
        Navigator.pushReplacementNamed(context, loginRoute);
      });
    } else if (shouldLogin) {
      _l.log(sectionName, 'Executing Login Route', always: false);
      Navigator.pushReplacementNamed(context, loginRoute);
    } else {
      _l.log(sectionName, 'Executing Home Route', linenumber: _l.lineNumber(StackTrace.current));
      Navigator.pushReplacementNamed(context, homeRoute);
    }
  }
}
