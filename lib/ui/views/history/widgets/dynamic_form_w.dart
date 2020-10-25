import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/history/models/item.dart';

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
    for (var item in widget.items) {
      switch (item.type) {
        case 'string':
          _formWidgets.add(buildTextInput(item));
          break;
        case 'checkbox':
          _formWidgets.add(buildCheckBox(item));
          break;
        case 'date':
          _formWidgets.add(buildDateInput(item));
          break;
        default:
          break;
      }
    }
    _formWidgets.add(snackBarWidget());

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

  Widget snackBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Processing Data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
            saveFormData();
          }
        },
        child: Text('Submit'),
      ),
    );
  }

  TextFormField buildTextInput(Item item) {
    var lastItem = false;
    if (item.lastItem != null && item.lastItem) lastItem = true;

    return TextFormField(
      style: TextStyle(color: Colors.black),
      textInputAction: lastItem ? TextInputAction.done : TextInputAction.next,
      onEditingComplete: () {
        print('onEditingComplete');
        if (lastItem) SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      onFieldSubmitted: (value) {
        print('onFieldSubmitted with VALUE: $value');
        if (!lastItem)
          FocusScope.of(context).nextFocus();
        else
          FocusScope.of(context).unfocus();
      },
      onSaved: (value) {
        print('onSaved with VALUE: $value');
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.yellow,
        isCollapsed: true,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        hintText: item.hintText,
      ),
    );
  }

  Widget buildCheckBox(Item item) {
    return Container();
  }

  Widget buildDateInput(Item item) {
    var lastItem = false;
    if (item.lastItem != null && item.lastItem) lastItem = true;

    return TextFormField(
      style: TextStyle(color: Colors.black),
      textInputAction: lastItem ? TextInputAction.done : TextInputAction.next,
      onEditingComplete: () {
        print('onEditingComplete');
        if (lastItem) SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      onFieldSubmitted: (value) {
        print('onFieldSubmitted with VALUE: $value');
        if (!lastItem)
          FocusScope.of(context).nextFocus();
        else
          FocusScope.of(context).unfocus();
      },
      onSaved: (value) {
        print('onSaved with VALUE: $value');
      },
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.yellow,
        isCollapsed: true,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        hintText: 'What do people call you?',
      ),
    );
  }

  void saveFormData() {
    var controller = ExpandableController.of(context);

    _formKey.currentState.save();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (controller.expanded) controller.toggle();
  }
}
