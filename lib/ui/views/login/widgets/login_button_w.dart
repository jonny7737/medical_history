import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:sized_context/sized_context.dart';

class LoginButtonWidget extends HookWidget {
  final Function onButtonClick;

  LoginButtonWidget(this.onButtonClick);

  @override
  Widget build(BuildContext context) {
    var _kbVisible = context.mq.viewInsets.bottom > 10;
    bool _smallScreen = context.diagonalInches < 5.0;
    bool _mediumScreen = !_smallScreen && context.diagonalInches < 5.6;
    bool _largeScreen = context.diagonalInches > 5.6;

//    print("Dia Inches: ${context.diagonalInches}");
//    print("$_smallScreen : $_mediumScreen : $_largeScreen");

    double top;
    if (_smallScreen) {
      top = _kbVisible ? context.heightPct(0.36) : context.heightPct(0.75);
    } else if (_mediumScreen) {
      top = _kbVisible ? context.heightPct(0.42) : context.heightPct(0.65);
    } else if (_largeScreen) {
      top = _kbVisible ? context.heightPct(0.43) : context.heightPct(0.60);
    }

    final themeProvider = useProvider(themeDataProvider);

    return AnimatedPositioned(
      duration: Duration(milliseconds: themeProvider.animDuration),
      top: top,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: themeProvider.appMargin,
          right: themeProvider.appMargin,
        ),
        child: RaisedButton(
          animationDuration: Duration(milliseconds: 750),
          color: themeProvider.themeData.colorScheme.primary,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            onButtonClick();
          },
        ),
      ),
    );
  }
}
