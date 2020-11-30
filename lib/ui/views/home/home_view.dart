import 'package:flutter/material.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/user_model.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/home/widgets/custom_drawer.dart';
import 'package:medical_history/ui/views/home/widgets/home_view_widget.dart';

class HomeView extends StatelessWidget {
  final Logger _l = locator();
  final UserModel _userModel = locator();

  @override
  Widget build(BuildContext context) {
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);
    _l.log(sectionName, '(re)Building', linenumber: _l.lineNumber(StackTrace.current));

    if (!_userModel.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _l.log(sectionName, 'Navigating to Login view',
            linenumber: _l.lineNumber(StackTrace.current));
        Navigator.pushReplacementNamed(context, loginRoute);
        return;
      });
    }

    if (!_userModel.isLoggedIn) return const NoContent();

    return CustomDrawer(child: HomeViewWidget());
  }
}

class NoContent extends StatelessWidget {
  const NoContent();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Text(
              'Logging out!',
              style: TextStyle(fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
