import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:sized_context/sized_context.dart';

/// returns an AnimatedPositioned widget for a Stack
class LogoWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = useProvider(themeDataProvider);

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    bool _smallScreen = context.diagonalInches < 5.0;
    bool _mediumScreen = !_smallScreen && context.diagonalInches < 5.6;
    bool _largeScreen = context.diagonalInches > 5.6;

    double topPos;
    double lrPos;

    if (_smallScreen) {
      topPos = _kbVisible ? context.heightPct(0.14) : context.heightPct(0.18);
      lrPos = _kbVisible ? context.widthPct(0.30) : context.widthPct(0.10);
    } else if (_mediumScreen) {
      topPos = _kbVisible ? context.heightPct(0.13) : context.heightPct(0.18);
      lrPos = _kbVisible ? context.widthPct(0.22) : context.widthPct(0.10);
    } else if (_largeScreen) {
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
