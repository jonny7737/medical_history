import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:medical_history/ui/views/home/widgets/custom_drawer.dart';
import 'package:sized_context/sized_context.dart';

class HomeAppBar extends HookWidget implements PreferredSizeWidget {
  final Logger _l = locator();

  bool get isDebugMode {
    bool debugMode = false;
    assert(debugMode = true);
    return debugMode;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = useProvider(themeDataProvider);
    final user = useProvider(userProvider);

    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return AppBar(
      backgroundColor: themeProvider.isDarkTheme ? Colors.black87 : null,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => CustomDrawer.of(context).open(),
          );
        },
      ),
      title: user.name == null
          ? Text('Not Logged In')
          : Center(
              child: Container(
                width: context.widthPct(0.65),
                child: Text(
                  'Welcome\n${user.name}',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      actions: <Widget>[
        if (isDebugMode)
          IconButton(
            tooltip: "Fake session expire",
            icon: Icon(Icons.clear, color: Colors.white),
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              _l.log(sectionName, 'Logout action', linenumber: _l.lineNumber(StackTrace.current));
              context.read(homeViewModel).logout();
              // Navigator.pushReplacementNamed(context, loginRoute);
            },
          ),
        if (isDebugMode)
          IconButton(
            tooltip: "reAnimate Home Screen",
            icon: Icon(Icons.autorenew, color: Colors.white),
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              context.read(homeViewModel).reAnimate();
            },
          ),
        IconButton(
          tooltip: "Dark Mode On/Off",
          icon: Icon(
            themeProvider.isDarkTheme ? Icons.brightness_medium : Icons.brightness_3,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            context.read(themeDataProvider).toggleTheme();
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
