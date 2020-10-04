import 'package:flutter/material.dart';
import 'package:medical_history/ui/views/logger/logger_menu_w.dart';

class LoggerMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Log Options'),
        ),
        body: LoggerMenuWidget(),
      ),
    );
  }
}
