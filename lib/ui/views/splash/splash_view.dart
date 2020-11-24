import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/secure_storage.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:sized_context/sized_context.dart';

class SplashView extends HookWidget {
  final Logger _l = locator();
  final ScreenInfoViewModel _s = locator();
  final SecureStorage _ss = locator();

  final splashViewModel = ChangeNotifierProvider<SplashViewModel>((_) => SplashViewModel());

  @override
  Widget build(BuildContext context) {
    final user = useProvider(userProvider);
    final vm = useProvider(splashViewModel);
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    double _margin;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context == null) return;
      runLater(context, vm, sectionName, user.hasPermission, user.shouldLogin);
    });

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    if (_kbVisible && (_s.isSmallScreen || _s.isMediumScreen)) {
      _margin = context.widthPct(0.30);
    } else if (!_kbVisible || _s.isLargeScreen) _margin = useProvider(themeDataProvider).appMargin;

    return SafeArea(
      child: Scaffold(
        key: UniqueKey(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: null,
                margin: EdgeInsets.symmetric(horizontal: _margin),
                child: Image.asset(
                  "assets/meds.png",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.hasPermission
                    ? 'Verifying storage permission...'
                    : 'Waiting for storage permission...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              SpinKitDoubleBounce(
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void runLater(BuildContext context, SplashViewModel vm, String sectionName, bool hasPermission,
      bool shouldLogin) async {
    await Future.delayed(Duration(seconds: 2));

    if (context == null) return;

    if (!hasPermission) {
      _l.log(sectionName, 'Rebuild initiated');
      vm.rebuild();
      return;
    }
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

class SplashViewModel with ChangeNotifier {
  void rebuild() => notifyListeners();
}
