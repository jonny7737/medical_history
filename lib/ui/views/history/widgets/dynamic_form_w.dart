import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/history/models/item.dart';
import 'package:medical_history/ui/views/history/widgets/form_widgets.dart';

class DynamicForm extends StatefulWidget {
  DynamicForm(this.items);

  final List<Item> items;

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  List<Widget> _formWidgets = [];

  @override
  void initState() {
    assembleForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _formWidgets,
      ),
    );
  }

  void saveFormData() {
    var controller = ExpandableController.of(context);

    _formKey.currentState.save();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (controller.expanded) controller.toggle();
  }

  void assembleForm() {
    _formWidgets.add(SizedBox(height: 10));
    for (var item in widget.items) {
      switch (item.type) {
        case 'string':
          _formWidgets.add(TextInputWidget(item: item));
          break;
        case 'checkbox':
          _formWidgets.add(CheckBoxWidget(item: item));
          break;
        case 'date':
          _formWidgets.add(DateInputWidget(item: item));
          break;
        default:
          break;
      }
    }
    _formWidgets.add(SizedBox(height: 20));
    _formWidgets.add(SubmitButton(_formKey, saveFormData));
  }
}
