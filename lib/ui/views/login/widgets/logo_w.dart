import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:sized_context/sized_context.dart';

/// returns an AnimatedPositioned widget for a Stack
class LogoWidget extends HookWidget {
  final ScreenInfoViewModel _s = locator();

  @override
  Widget build(BuildContext context) {
    final themeProvider = useProvider(themeDataProvider);

    bool _kbVisible = context.mq.viewInsets.bottom > 10;

    double topPos;
    double lrPos;

    if (_s.isSmallScreen) {
      topPos = _kbVisible ? context.heightPct(0.14) : context.heightPct(0.18);
      lrPos = _kbVisible ? context.widthPct(0.30) : context.widthPct(0.10);
    } else if (_s.isMediumScreen) {
      topPos = _kbVisible ? context.heightPct(0.13) : context.heightPct(0.18);
      lrPos = _kbVisible ? context.widthPct(0.22) : context.widthPct(0.10);
    } else if (_s.isLargeScreen) {
      topPos = _kbVisible ? context.heightPct(0.10) : context.heightPct(0.14);
      lrPos = _kbVisible ? context.widthPct(0.15) : context.widthPct(0.10);
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: themeProvider.animDuration),
      top: topPos,
      left: lrPos,
      right: lrPos,
      child: Container(
        child: Image.asset("assets/meds.png"),
      ),
    );
  }
}
