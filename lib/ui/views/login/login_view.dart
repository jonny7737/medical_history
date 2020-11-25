import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/ui/views/login/widgets/login_w.dart';

/// TODO: Rethink and refactor this view entirely.
class LoginView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: useProvider(themeDataProvider).isDarkTheme ? Colors.black87 : null,
          title: Text('Login'),
          actions: <Widget>[
            IconButton(
                tooltip: "Dark Mode On/Off",
                icon: Icon(
                  useProvider(themeDataProvider).isDarkTheme
                      ? Icons.brightness_medium
                      : Icons.brightness_3,
                ),
                onPressed: () {
                  context.read(themeDataProvider).toggleTheme();
                })
          ],
        ),
        body: LoginWidget(),
      ),
    );
  }
}
