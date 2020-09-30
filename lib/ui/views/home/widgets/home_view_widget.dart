import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/ui/views/home/widgets/app_bar_w.dart';
import 'package:medical_history/ui/views/home/widgets/error_msg_w.dart';
import 'package:medical_history/ui/views/home/widgets/logo_w.dart';
import 'package:sized_context/sized_context.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';

class HomeViewWidget extends HookWidget {
  HomeViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.read(homeViewModel).runOnce == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read(homeViewModel).startAnimations();
      });
      context.read(homeViewModel).runOnce = true;
    }

    print('HomeViewWidget rebuilding');

    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: Stack(
          children: <Widget>[
            Activity('records'),
            Activity('doctors'),
            const ErrorMsgWidget(),
            LogoWidget(),
          ],
        ),
      ),
    );
  }
}

class Activity extends HookWidget {
  Activity(this.activityName);
  final String activityName;

  @override
  Widget build(BuildContext context) {
    double lo = context.read(homeViewModel).iconLeft[activityName];
    double ro = context.read(homeViewModel).iconRight[activityName];

    if (lo != null) return LeftActivity(activityName: activityName);
    if (ro != null) return RightActivity(activityName: activityName);
    return Material();
  }
}

class LeftActivity extends HookWidget {
  LeftActivity({Key key, @required this.activityName}) : super(key: key);

  final _model = useProvider(homeViewModel);

  final String activityName;

  @override
  Widget build(BuildContext context) {
    double leftOffset = _model.iconLeft[activityName] != null
        ? context.widthPct(_model.iconLeft[activityName])
        : null;

    final double imageSize = context.heightPct(0.20);

    return AnimatedPositioned(
      top: context.heightPct(_model.iconTop[activityName]),
      left: leftOffset,
      duration: Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        elevation: 10,
        child: Image(
          height: imageSize,
          width: imageSize,
          image: AssetImage(
            "assets/meds.png",
          ),
        ),
      ),
    );
  }
}

class RightActivity extends HookWidget {
  RightActivity({Key key, @required this.activityName}) : super(key: key);

  final _model = useProvider(homeViewModel);
  final String activityName;

  @override
  Widget build(BuildContext context) {
    double rightOffset = _model.iconRight[activityName] != null
        ? context.widthPct(_model.iconRight[activityName])
        : null;

    final double imageSize = context.heightPct(0.20);

    return AnimatedPositioned(
      top: context.heightPct(_model.iconTop[activityName]),
      right: rightOffset,
      duration: Duration(milliseconds: 500),
      child: Material(
        color: Colors.transparent,
        elevation: 10,
        child: Image(
          height: imageSize,
          width: imageSize,
          image: AssetImage(
            "assets/meds.png",
          ),
        ),
      ),
    );
  }
}
