import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/secure_storage.dart';
import 'package:medical_history/ui/views/splash/splash_view_w.dart';

class SplashView extends HookWidget {
  final Logger _l = locator();
  final SecureStorage _ss = locator();

  @override
  Widget build(BuildContext context) {
    final user = useProvider(userProvider);

    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    Future<bool> hasPermission = user.requestPermission();

    return FutureBuilder(
        future: hasPermission,
        builder: (_, snapshot) {
          if (snapshot.hasData)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              runLater(context, sectionName, user.hasPermission, user.shouldLogin);
            });
          return SplashViewWidget();
        });
  }

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
