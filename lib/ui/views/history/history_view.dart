import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Medical History'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("medical_history: history_view");
            },
          )
        ],
      ),
      body: Container(),
    );
  }
}
