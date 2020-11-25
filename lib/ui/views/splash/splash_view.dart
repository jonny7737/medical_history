import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/splash/splash_view_w.dart';
import 'package:medical_history/ui/views/splash/splash_viewmodel.dart';

class SplashView extends HookWidget {
  final Logger _l = locator();
  final SplashViewModel splashViewModel = SplashViewModel();

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
              splashViewModel.runLater(context, sectionName, user.hasPermission, user.shouldLogin);
            });
          return SplashViewWidget();
        });
  }
}
