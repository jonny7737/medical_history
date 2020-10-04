import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:sized_context/sized_context.dart';

class Activity extends HookWidget {
  final String activityName;

  const Activity(this.activityName);

  @override
  Widget build(BuildContext context) {
    final ScreenInfoViewModel _s = locator();
    final _model = useProvider(homeViewModel);

    final double leftOffset = _model.iconLeft[activityName] != null
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
            Navigator.pushNamed(context, _model.activityRoute(activityName));
          },
          child: Image(
            height: imageSize,
            width: imageSize,
            image: AssetImage(_model.activityIcon(activityName)),
          ),
        ),
      ),
    );
  }
}
