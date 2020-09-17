import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/mixins/logger.dart';
import 'package:medical_history/ui/themes/theme_data_provider.dart';
import 'package:medical_history/ui/view_model/logger_provider.dart';
import 'package:medical_history/ui/view_model/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(ProviderScope(child: MyApp()));
}

final themeProvider = ChangeNotifierProvider((_) => ThemeDataProvider());
final userProvider = ChangeNotifierProvider((_) => UserProvider());
final loggerProvider = ChangeNotifierProvider((ref) => LoggerProvider());

class MyApp extends HookWidget with Logger {
  @override
  Widget build(BuildContext context) {
    /// Ensure these Providers have completed setup before proceeding
    if (!useProvider(themeProvider).isInitialized ||
        useProvider(userProvider).isLoggedIn == null ||
        !useProvider(loggerProvider).isInitialized)
      return Material(
        color: Colors.yellow[300],
        child: CircularProgressIndicator(),
      );

    setLogging(true);
    log('(re)building', linenumber: lineNumber(StackTrace.current), always: true);

    return MaterialApp(
      color: Colors.yellow[100],
      debugShowCheckedModeBanner: false,
      title: 'Medical History',
      theme: useProvider(themeProvider).themeData.copyWith(
            textTheme: Typography.blackMountainView,
          ),
      home: HomeView(),
    );
  }
}

class HomeView extends HookWidget with Logger {
  HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setLogging(true);
    log('(re)building', linenumber: lineNumber(StackTrace.current), always: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Medical History'),
          actions: [
            IconButton(
              tooltip: "Dark Mode On/Off",
              icon: Icon(
                useProvider(themeProvider).isDarkTheme
                    ? Icons.brightness_medium
                    : Icons.brightness_3,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                context.read(themeProvider).toggleTheme();
                log('User logged in: ${context.read(userProvider).isLoggedIn}',
                    linenumber: lineNumber(StackTrace.current), always: true);
              },
            )
          ],
        ),
        body: Center(
          child: Text(
            'Hello World',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ),
      ),
    );
  }
}
