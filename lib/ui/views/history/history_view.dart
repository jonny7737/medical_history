import 'package:flutter/material.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';

class HistoryView extends StatelessWidget {
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Medical History'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _l.log(sectionName, 'Patient Medical History',
                  linenumber: _l.lineNumber(StackTrace.current));
            },
          )
        ],
      ),
      body: Container(),
    );
  }
}
