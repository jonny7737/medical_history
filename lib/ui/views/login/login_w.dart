import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/login/riverpods.dart';
import 'package:medical_history/ui/views/login/widgets/login_button_w.dart';
import 'package:medical_history/ui/views/login/widgets/logo_w.dart';
import 'package:medical_history/ui/views/login/widgets/user_name_w.dart';
import 'package:sized_context/sized_context.dart';

class LoginWidget extends HookWidget {
  final Logger _l = locator();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {'name': null};

  @override
  Widget build(BuildContext context) {
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return Container(
      height: context.heightPx,
      child: Stack(
        children: <Widget>[
          UserNameWidget(formKey: _formKey, formData: _formData),
          LogoWidget(),
          LoginButtonWidget(() {
            if (!context.read(userProvider).hasPermission) {
              context.read(userProvider).requestPermission();
              return;
            }
            if (_formData['name'] != null && _formData['name'].length > 2) {
              _formKey.currentState.save();
              _l.log(
                sectionName,
                "Login name: ${_formData['name']}",
                linenumber: _l.lineNumber(StackTrace.current),
              );
              context.read(userProvider).login(_formData['name']);
              _formData['name'] = null;

              Navigator.pushReplacementNamed(context, homeRoute);
            } else
              context.read(viewModel).showNameError();
          }),
        ],
      ),
    );
  }
}
