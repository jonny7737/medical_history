import 'package:flutter/material.dart';

import 'package:medical_history/ui/views/add_med/widgets/add_med_view_w.dart';

class AddMedArguments {
  final int editIndex;

  AddMedArguments({this.editIndex});
}

class AddMedView extends StatelessWidget {
  AddMedView(this.editIndex);
  final int editIndex;

  @override
  Widget build(BuildContext context) {
    return AddMedWidget(editIndex: editIndex);
  }
}
