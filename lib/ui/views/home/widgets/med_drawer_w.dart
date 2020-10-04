import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/home/riverpods.dart';
import 'package:sized_context/sized_context.dart';

class MedDrawer extends HookWidget {
  final Logger _l = locator();
  final ScreenInfoViewModel _s = locator();

  MedDrawer(this.toggleDrawer);

  final Function toggleDrawer;

  bool get isDebugMode {
    bool debugMode = false;
    assert(debugMode = true);
    return debugMode;
  }

  @override
  Widget build(BuildContext context) {
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    double fontSize = context.heightPct(_s.isLargeScreen ? 0.023 : 0.028) * _s.fontScale;

    return SafeArea(
      child: Material(
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(
                width: double.infinity,
                height: context.heightPct(0.16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: useProvider(themeDataProvider).appMargin,
              ),
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: context.heightPct(0.10),
                    child: Image.asset("assets/meds.png"),
                  ),
                  Text(
                    'Options',
                    style: TextStyle(
                      fontSize: context.heightPct(0.03),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                context.read(userProvider).logout();
                Navigator.pushReplacementNamed(context, loginRoute);
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.add_circle),
            //   title: Text(
            //     'Manage Medications',
            //     style: TextStyle(fontSize: fontSize),
            //   ),
            //   onTap: () async {
            //     var numberOfDoctors = context.read(homeViewModel).numberOfDoctors;
            //     _l.log(sectionName, 'Number of Doctors available: $numberOfDoctors');
            //     if (numberOfDoctors == 0) {
            //       context.read(homeViewModel).showAddMedError(); // _model.showAddMedError();
            //       return;
            //     } else {
            //       toggleDrawer();
            //       bool result = await Navigator.pushNamed<bool>(context, addMedRoute);
            //       if (result != null && result) {
            //         context.read(homeViewModel).modelDirty(true); //_model.modelDirty(true);
            //       }
            //     }
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.add_circle),
            //   title: Text(
            //     'Manage Doctors',
            //     style: TextStyle(fontSize: fontSize),
            //   ),
            //   onTap: () async {
            //     toggleDrawer();
            //     bool result = await Navigator.pushNamed(context, doctorRoute);
            //     if (result != null && result) {
            //       context.read(homeViewModel).modelDirty(true); //_model.modelDirty(true);
            //     }
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text(
                'Clear ALL Data',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                _l.log(sectionName, 'Clear all data',
                    linenumber: _l.lineNumber(StackTrace.current));
                context.read(homeViewModel).clearListData(); //_model.clearListData();
              },
            ),
            if (isDebugMode)
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  'Log Options',
                  style: TextStyle(fontSize: fontSize),
                ),
                onTap: () {
                  toggleDrawer();
                  Navigator.pushNamed(context, loggerMenuRoute);
                },
              ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                /**
                 * TODO: Convert showAboutDialog to a custom widget
                    so that all elements can be configured.
                 **/
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/meds.png',
                    height: context.heightPct(0.15),
                  ),
                  applicationName: 'Medical History',
                  applicationVersion: '${_s.version}+${_s.buildNumber}',
                  children: [
                    Text(
                      'All drug information is provided by U.S. National Institute of Health API.'
                      '  Not appropriate for use with non-U.S. drugs.\n',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    ),
                    Text(
                      'Icon made by Dark Web from www.flaticon.com\n',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    ),
                    Text(
                      'Icon made by ultimatearm from www.flaticon.com\n',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    ),
                    Text(
                      'Icons made by Freepik from www.Flaticon.com\n',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    ),
                    Text(
                      'Options drawer made by\n\t\tMarcin Szałek',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    )
                  ],
                );
              },
            ),
            if (isDebugMode)
              ListTile(
                leading: Icon(Icons.edit),
                title: Text(
                  'Painter Testing',
                  style: TextStyle(fontSize: fontSize),
                ),
                onTap: () {
                  toggleDrawer();
                  Navigator.pushNamed(context, keygenRoute);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class AppAboutListTile extends AboutListTile {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
