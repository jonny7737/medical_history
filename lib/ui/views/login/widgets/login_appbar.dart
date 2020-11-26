import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';

class LoginAppBar extends HookWidget implements PreferredSizeWidget {
  const LoginAppBar();

  @override
  Widget build(BuildContext context) {
    final Logger _l = locator();
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
