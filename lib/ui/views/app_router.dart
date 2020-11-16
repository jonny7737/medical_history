import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/logger_model.dart';
import 'package:medical_history/ui/views/add_med/add_med_view.dart';
import 'package:medical_history/ui/views/add_med/widgets/meds_loaded_sub_view.dart';
import 'package:medical_history/ui/views/doctors/doctors_view.dart';
import 'package:medical_history/ui/views/doctors/widgets/add_doctor_form.dart';
import 'package:medical_history/ui/views/history/history_view.dart';
import 'package:medical_history/ui/views/home/home_view.dart';
import 'package:medical_history/ui/views/keygen/keygen_view.dart';
import 'package:medical_history/ui/views/logger/logger_menu_view.dart';
import 'package:medical_history/ui/views/login/login_view.dart';
import 'package:medical_history/ui/views/meds/meds_view.dart';
import 'package:medical_history/ui/views/setup/setup_screen_info.dart';
import 'package:medical_history/ui/views/splash/splash_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String sectionName = 'Router';
    LoggerModel _model = locator();
    _model.initSectionPref(sectionName);
    bool isLogging = _model.isEnabled(sectionName) && _model.isEnabled(LOGGING_APP);
    if (isLogging)
      print('[Router.21] => ${settings.name}  Arguments: ${settings.arguments.toString()}');

    switch (settings.name) {
      case setupRoute:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => SetupScreenInfo(),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
      case splashRoute:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => SplashView(),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
      case loggerMenuRoute:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoggerMenuView(),
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return effectMap[PageTransitionType.slideUp](
              Curves.linear,
              animation,
              secondaryAnimation,
              child,
            );
          },
        );
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );
      case homeRoute:
        if (isLogging) print('[Router.83] => About to execute Home route');
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeView(),
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return effectMap[PageTransitionType.fadeIn](
              Curves.linear,
              animation,
              secondaryAnimation,
              child,
            );
          },
        );
      case medsRoute:
        return MaterialPageRoute<bool>(
          builder: (_) => MedsView(),
        );
      case addMedRoute:
        AddMedArguments args = settings.arguments;
        int _editIndex;
        if (args != null) _editIndex = args.editIndex;
        return MaterialPageRoute<bool>(
          builder: (_) => AddMedView(_editIndex),
        );
      case medsLoadedRoute:
        return PageRouteBuilder<bool>(
          pageBuilder: (_, __, ___) => MedsLoadedSubView(),
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return effectMap[PageTransitionType.fadeIn](
              Curves.linear,
              animation,
              secondaryAnimation,
              child,
            );
          },
        );
      case doctorRoute:
        return MaterialPageRoute<bool>(builder: (_) => DoctorsView());
      case addDoctorRoute:
        return MaterialPageRoute<bool>(builder: (_) => AddDoctorForm());
      case keygenRoute:
        return MaterialPageRoute<bool>(builder: (_) => KeyGenView());
      case historyRoute:
        return MaterialPageRoute(builder: (_) => HistoryView());
      default:
        return MaterialPageRoute<bool>(
          builder: (_) => SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(
                  'No route defined for ${settings.name}',
                  style: TextStyle(fontSize: 28, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
    }
  }
}
