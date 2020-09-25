import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/ui/views/login/riverpods.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter/material.dart';

class FormErrorWidget extends HookWidget {
  final String errorMsg;

  FormErrorWidget({this.errorMsg});

  @override
  Widget build(BuildContext context) {
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
          height: useProvider(viewModel).errorMsgHeight,
          width: context.widthPct(0.60),
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 10),
          child: Text(
            errorMsg,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
