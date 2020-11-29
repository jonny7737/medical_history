import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:sized_context/sized_context.dart';

class Activity extends HookWidget {
  final ScreenInfoViewModel _s = locator();
  final String activityName;

  Activity(this.activityName);

  @override
  Widget build(BuildContext context) {
    final _model = useProvider(homeViewModel);

    final double leftOffset = context.widthPct(_model.iconLeft[activityName] ?? 0);

    final double imageSize = context.heightPct(_s.isLargeScreen ? 0.15 : 0.20);

    // print('(re)Building Activity: $activityName');

    return AnimatedPositioned(
      top: context.heightPct(context.read(homeViewModel).iconTop[activityName]),
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
            if (activityName == kMedsActivity && context.read(homeViewModel).numberOfDoctors == 0) {
              context.read(homeViewModel).showAddMedError();
              return;
            }
            Navigator.pushNamed(context, context.read(homeViewModel).activityRoute(activityName));
          },
          child: Image(
            height: imageSize,
            width: imageSize,
            image: AssetImage(context.read(homeViewModel).activityIcon(activityName)),
          ),
        ),
      ),
    );
  }
}
