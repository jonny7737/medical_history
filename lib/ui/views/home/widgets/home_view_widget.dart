import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/user_model.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:medical_history/ui/views/home/widgets/activity.dart';
import 'package:medical_history/ui/views/home/widgets/app_bar_w.dart';
import 'package:medical_history/ui/views/home/widgets/error_msg_w.dart';
import 'package:medical_history/ui/views/home/widgets/logo_w.dart';
import 'package:medical_history/core/constants.dart';

class HomeViewWidget extends HookWidget {
  final Logger _l = locator();
  final UserModel _user = locator();

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    _l.log(sectionName, '(Re)building', linenumber: _l.lineNumber(StackTrace.current));

    if (!_user.isLoggedIn) return Container();

    if (context.read(homeViewModel).runOnce == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (context == null) return;
        context.read(homeViewModel).reAnimate();
      });
      context.read(homeViewModel).runOnce = true;
    }

    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: Stack(
          children: <Widget>[
            Activity(kMedsActivity),
            Activity(kRecordsActivity),
            Activity(kDoctorsActivity),
            const ErrorMsgWidget(),

            /// Remove the logo from the stack after opacity goes to 0.0.
            /// If not removed, it will cover Activity icons and prevent taps.
            if (context.read(homeViewModel).isLogoAnimating ||
                context.read(homeViewModel).logoOpacity > 0.0)
              LogoWidget(),
          ],
        ),
      ),
    );
  }
}
