import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';

import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/home/widgets/app_bar_w.dart';
import 'package:medical_history/ui/views/home/widgets/error_msg_w.dart';
import 'package:medical_history/ui/views/home/widgets/logo_w.dart';
import 'package:sized_context/sized_context.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';

class HomeViewWidget extends HookWidget {
  HomeViewWidget({Key key}) : super(key: key);
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    if (context.read(homeViewModel).runOnce == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (context == null) return;
        context.read(homeViewModel).reAnimate();
      });
      context.read(homeViewModel).runOnce = true;
    }

    _l.log(sectionName, '(Re)building', linenumber: _l.lineNumber(StackTrace.current));

    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: Stack(
          children: <Widget>[
            MedsActivity(),
            HistoryActivity(),
            DoctorActivity(),
            const ErrorMsgWidget(),

            /// Remove the logo from the stack after opacity goes to 0.0.
            /// If not removed, it will cover Activity icons and prevent taps.
            if (useProvider(homeViewModel).isLogoAnimating ||
                useProvider(homeViewModel).logoOpacity > 0.0)
              LogoWidget(),
          ],
        ),
      ),
    );
  }
}

class HistoryActivity extends HookWidget {
  HistoryActivity({Key key}) : super(key: key);

  final ScreenInfoViewModel _s = locator();
  final _model = useProvider(homeViewModel);
  final String activityName = 'records';

  @override
  Widget build(BuildContext context) {
    double leftOffset = _model.iconLeft[activityName] != null
        ? context.widthPct(_model.iconLeft[activityName])
        : null;

    final double iconScale = _s.isLargeScreen ? 0.15 : 0.20;
    final double imageSize = context.heightPct(iconScale);

    return AnimatedPositioned(
      top: context.heightPct(_model.iconTop[activityName]),
      left: leftOffset,
      duration: Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        borderRadius:
            BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        elevation: 20,
        child: InkWell(
          onTap: () {
            SystemSound.play(SystemSoundType.click);
            Navigator.pushNamed(context, historyRoute);
          },
          child: Image(
            height: imageSize,
            width: imageSize,
            image: AssetImage("assets/medical-history.png"),
          ),
        ),
      ),
    );
  }
}

class DoctorActivity extends HookWidget {
  DoctorActivity({Key key}) : super(key: key);

  final ScreenInfoViewModel _s = locator();
  final _model = useProvider(homeViewModel);
  final String activityName = 'doctors';

  @override
  Widget build(BuildContext context) {
    double rightOffset = _model.iconRight[activityName] != null
        ? context.widthPct(_model.iconRight[activityName])
        : null;

    final double iconScale = _s.isLargeScreen ? 0.15 : 0.20;
    final double imageSize = context.heightPct(iconScale);

    return AnimatedPositioned(
      top: context.heightPct(_model.iconTop[activityName]),
      right: rightOffset,
      duration: Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        elevation: 20,
        child: InkWell(
          onTap: () {
            SystemSound.play(SystemSoundType.click);
            Navigator.pushNamed(context, doctorRoute);
          },
          child: Image(
            height: imageSize,
            width: imageSize,
            image: AssetImage(
              "assets/doctor-1.png",
            ),
          ),
        ),
      ),
    );
  }
}

class MedsActivity extends HookWidget {
  MedsActivity({Key key}) : super(key: key);

  final ScreenInfoViewModel _s = locator();
  final _model = useProvider(homeViewModel);
  final String activityName = 'meds';

  @override
  Widget build(BuildContext context) {
    double rightOffset = _model.iconRight[activityName] != null
        ? context.widthPct(_model.iconRight[activityName])
        : null;

    final double iconScale = _s.isLargeScreen ? 0.15 : 0.20;
    final double imageSize = context.heightPct(iconScale);

    return AnimatedPositioned(
      top: context.heightPct(_model.iconTop[activityName]),
      right: rightOffset,
      duration: Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        elevation: 20,
        child: InkWell(
          onTap: () async {
            SystemSound.play(SystemSoundType.click);
            if (_model.numberOfDoctors == 0) {
              _model.showAddMedError();
              return;
            }
            bool result = await Navigator.pushNamed<bool>(context, addMedRoute);
            if (result != null && result) {
              context.read(homeViewModel).modelDirty(true);
            }
          },
          child: Image(
            height: imageSize,
            width: imageSize,
            image: AssetImage(
              "assets/drug-2.png",
            ),
          ),
        ),
      ),
    );
  }
}
