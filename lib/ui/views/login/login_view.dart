import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/user_provider.dart';
import 'package:medical_history/ui/views/login/riverpods.dart';
import 'package:medical_history/ui/views/login/widgets/login_appbar.dart';
import 'package:medical_history/ui/views/login/widgets/login_button_w.dart';
import 'package:medical_history/ui/views/login/widgets/logo_w.dart';
import 'package:medical_history/ui/views/login/widgets/user_name_w.dart';
import 'package:sized_context/sized_context.dart';

class LoginView extends HookWidget {
  final container = ProviderContainer();
  final Logger _l = locator();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {'name': null};

  @override
  Widget build(BuildContext context) {
    void onClick() => _onClick(context);

    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: LoginAppBar(),
        body: Container(
          height: context.heightPx,
          child: Stack(
            children: <Widget>[
              UserNameWidget(formKey: _formKey, formData: _formData),
              LogoWidget(),
              LoginButtonWidget(onClick),
            ],
          ),
        ),
      ),
    );
  }

  void _onClick(BuildContext context) {
    final UserProvider user = container.read(userProvider);
    final sectionName = this.runtimeType.toString();

    if (context == null) {
      print('--${_l.lineNumber(StackTrace.current)}--$context');
      return;
    }

    if (!user.hasPermission) {
      user.requestPermission();
      return;
    }
    if (_formData['name'] != null && _formData['name'].length > 2) {
      _formKey.currentState.save();
      _l.log(sectionName, "Login name: ${_formData['name']}",
          linenumber: _l.lineNumber(StackTrace.current));
      user.login(_formData['name']);
      _formData['name'] = null;

      Navigator.pushReplacementNamed(context, homeRoute);
    } else
      container.read(viewModel).showNameError();
  }
}
