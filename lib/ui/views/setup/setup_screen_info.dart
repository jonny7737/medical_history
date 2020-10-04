import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:sized_context/sized_context.dart';

class SetupScreenInfo extends HookWidget {
  final Logger _l = locator();
  final ScreenInfoViewModel _s = locator();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    if (_s.isSetup || _s.runningSetup) return Material(color: Colors.yellow[300]);
    _s.runningSetup = true;
    // _l.setLogging(_l.logsEnabled(LOGGING_APP));

    //  This is the first 'context' with a MediaQuery, therefore,
    //  this is the first opportunity to set these values.
    useProvider(themeDataProvider).setAppMargin(context.widthPct(0.10));

    _s.setPlatform(Theme.of(context).platform);
    _s.setScreenSize(context.diagonalInches);

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    if (_kbVisible) SystemChannels.textInput.invokeMethod('TextInput.hide');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context == null) return;
      _l.log(sectionName, 'Navigating to SplashPage');
      Navigator.pushReplacementNamed(context, splashRoute);
    });

    _l.log(sectionName, '(re)building',
        linenumber: _l.lineNumber(StackTrace.current), always: false);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Material(color: Colors.yellow[300]),
      ),
    );
  }
}
