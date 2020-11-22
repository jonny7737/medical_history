import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/history/models/item.dart';

///************************************************************************
class DateInputWidget extends StatelessWidget {
  DateInputWidget({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    var lastItem = false;
    if (item.lastItem != null && item.lastItem) lastItem = true;

    return TextFormField(
      initialValue: item.value,
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
        // print('onSaved ${item.id}:${item.label} with VALUE: [$value] is !MT [${value.isEmpty}]');
        item.setValue(value);
      },
      decoration: InputDecoration(
        filled: true,
        // fillColor: Colors.yellow,
        isCollapsed: true,
        hintText: item.hintText,
      ),
    );
  }
}

///************************************************************************
class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

///************************************************************************
class TextInputWidget extends StatelessWidget {
  const TextInputWidget({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    var lastItem = item.lastItem != null && item.lastItem;

    return TextFormField(
      initialValue: item.value,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
      textInputAction: lastItem ? TextInputAction.done : TextInputAction.next,
      onEditingComplete: () {
        print('onEditingComplete');
        if (lastItem) SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      onFieldSubmitted: (value) {
        print('onFieldSubmitted with VALUE: $value');
        if (lastItem)
          FocusScope.of(context).unfocus();
        else
          FocusScope.of(context).nextFocus();
      },
      onSaved: (value) {
        // print('onSaved ${item.id}:${item.label} with VALUE: $value');
        item.setValue(value);
      },
      decoration: InputDecoration(
        filled: true,
        isCollapsed: true,
        hintText: item.hintText,
      ),
    );
  }
}

///************************************************************************
class SubmitButton extends StatelessWidget {
  final _formKey;
  final Function saveData;

  const SubmitButton(this._formKey, this.saveData);

  @override
  Widget build(BuildContext context) {
    // ElevatedButton eb = ElevatedButton(onPressed: null, child: null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        child: Text('Submit', style: TextStyle(fontSize: 18)), // Customize elevatedButtonTheme
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Data saved', style: TextStyle(fontWeight: FontWeight.bold))),
            );
            saveData();
          }
        },
      ),
    );
  }
}
