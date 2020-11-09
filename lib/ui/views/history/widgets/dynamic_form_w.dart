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

class DateInputWidget extends StatelessWidget {
  const DateInputWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    var lastItem = false;
    if (item.lastItem != null && item.lastItem) lastItem = true;

    return TextFormField(
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
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
        print('onSaved ${item.id}:${item.label} with VALUE: $value');
      },
      decoration: InputDecoration(
        filled: true,
        // fillColor: Colors.yellow,
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
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TextInputWidget extends StatelessWidget {
  const TextInputWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    var lastItem = item.lastItem != null && item.lastItem;

    return TextFormField(
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
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
        print('onSaved ${item.id}:${item.label} with VALUE: $value');
      },
      decoration: InputDecoration(
        filled: true,
        // fillColor: Colors.yellow,
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
}

class SubmitButton extends StatelessWidget {
  final _formKey;
  final Function saveData;

  SubmitButton(this._formKey, this.saveData);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Data saved',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
            saveData();
          }
        },
        child: Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
