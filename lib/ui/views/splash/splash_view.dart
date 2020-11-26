import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/ui/views/splash/splash_view_w.dart';
import 'package:medical_history/ui/views/splash/splash_viewmodel.dart';

class SplashView extends HookWidget {
  final splashViewModel = Provider((_) => SplashViewModel());

  @override
  Widget build(BuildContext context) {
    final model = useProvider(splashViewModel);

    final sectionName = this.runtimeType.toString();

    return FutureBuilder(
        future: model.hasPermission,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // print('-$context');
              model.nextStep(context, sectionName);
            });
          if (snapshot.hasData && !snapshot.data) {
            /*
            TODO: Exiting the app is a hack.  Display a screen
               to explain why read/write permission is required.
            */
            SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // exit the app
          }
          return SplashViewWidget();
        });
  }
}
