import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:sized_context/sized_context.dart';

class ErrorMsgWidget extends HookWidget {
  const ErrorMsgWidget();

  @override
  Widget build(BuildContext context) {
    final _model = useProvider(homeViewModel);
    final ScreenInfoViewModel _s = locator();

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 4,
        color: Colors.red[800],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 275),
          alignment: Alignment.center,
          height: _model.errorMsgHeight,
          width: context.widthPct(kErrorMsgWidthPercent),
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 10),
          child: Text(
            _model.errorMsg,
            style: TextStyle(
              fontSize: _s.isiOSSmall ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
