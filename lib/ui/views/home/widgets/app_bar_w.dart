import 'package:flutter/material.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/views/home/widgets/custom_drawer.dart';

class HomeAppBar extends HookWidget implements PreferredSizeWidget {
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final themeProvider = useProvider(themeDataProvider);
    final user = useProvider(userProvider);
    final _model = useProvider(homeViewModel);

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
          : Container(
              width: context.widthPct(0.30),
              child: Text(
                'Welcome ${user.name}',
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
      actions: <Widget>[
        IconButton(
          tooltip: "Reanimate Home Screen",
          icon: Icon(Icons.autorenew, color: Colors.white),
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            _model.reAnimate();
          },
        ),
        IconButton(
          tooltip: "Add a new medication",
          icon: Icon(Icons.add_circle, color: Colors.white),
          padding: EdgeInsets.all(0.0),
          onPressed: () async {
            // _l.log(sectionName, 'Number of Doctors available: ${_model.numberOfDoctors}');
            if (_model.numberOfDoctors == 0) {
              _model.showAddMedError();
              // return;
            } else {
              bool result = await Navigator.pushNamed<bool>(context, addMedRoute);
              if (result != null && result) {
                _model.modelDirty(true);
              }
            }
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
