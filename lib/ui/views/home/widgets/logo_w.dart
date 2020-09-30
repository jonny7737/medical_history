import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:sized_context/sized_context.dart';

class LogoWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    double opacity = useProvider(homeViewModel).logoOpacity;
    return Positioned(
      top: context.heightPct(0.20),
      left: context.widthPct(0.10),
      right: context.widthPct(0.10),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 500),
        child: Container(
          height: context.widthPct(0.75),
          width: context.widthPct(0.75),
          child: Image.asset("assets/meds.png"),
        ),
      ),
    );
  }
}
