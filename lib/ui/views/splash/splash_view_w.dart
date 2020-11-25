import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:sized_context/sized_context.dart';

class SplashViewWidget extends HookWidget {
  final ScreenInfoViewModel _s = locator();

  @override
  Widget build(BuildContext context) {
    double _margin;

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    if (_kbVisible && (_s.isSmallScreen || _s.isMediumScreen)) {
      _margin = context.widthPct(0.30);
    } else if (!_kbVisible || _s.isLargeScreen) {
      _margin = context.read(themeDataProvider).appMargin;
    }

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
                'Waiting for storage permission...',
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
}
