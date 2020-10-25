import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/history/widgets/dynamic_form_w.dart';
import 'package:sized_context/sized_context.dart';

import 'package:medical_history/ui/views/history/models/item.dart';

class InputForm extends StatelessWidget {
  const InputForm(this.items, {Key key}) : super(key: key);

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    if (!ExpandableController.of(context).expanded)
      SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Material(
      color: Colors.transparent,
      elevation: 20,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow[200],
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(bottom: 30),
          height: context.heightPct(0.70),
          width: context.widthPct(0.90),

          /// Build form here
          child: items.isNotEmpty ? Center(child: DynamicForm(items)) : SizedBox(),
        ),
      ),
    );
  }
}
