import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/hive_setup.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  HiveSetup(purge: false);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  final Logger _l = locator();
  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();

    /// Ensure these Providers have completed setup before proceeding
    if (!initializationComplete())
      return Material(color: Colors.yellow[300], child: CircularProgressIndicator());

    _l.log(sectionName, '(re)building',
        linenumber: _l.lineNumber(StackTrace.current), always: false);

    return MaterialApp(
      color: Colors.yellow[100],
      debugShowCheckedModeBanner: false,
      title: 'Medical History',
      theme: useProvider(themeDataProvider).themeData,
      initialRoute: setupRoute,
      onGenerateRoute: Router.generateRoute,
    );
  }

  /// Test for initialization
  /// Adjust for global providers
  bool initializationComplete() {
    if (!useProvider(themeDataProvider).isInitialized ||
        useProvider(userProvider).isLoggedIn == null)
      return false;
    else
      return true;
  }
}
