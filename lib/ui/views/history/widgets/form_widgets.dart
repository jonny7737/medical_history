import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medical_history/ui/views/history/models/item.dart';

///************************************************************************
class ExpandableInputWidget extends StatelessWidget {
  const ExpandableInputWidget({Key key, @required this.items}) : super(key: key);
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];
    for (int i = 0; i < items.length; i += 2) {
      rowChildren.add(TextInputWidget(item: items[i]));
      if (items[i + 1].type == 'date')
        rowChildren.add(DateInputWidget(item: items[i + 1]));
      else if (items[i + 1].type == 'checkbox') rowChildren.add(CheckBoxWidget(item: items[i + 1]));
    }

    return Column(
      children: [
        Row(
          children: rowChildren,
        ),
      ],
    );
  }
}

///************************************************************************
class DateInputWidget extends HookWidget {
  DateInputWidget({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    List<MaskTextInputFormatter> maskTextInputFormatterList = [
      MaskTextInputFormatter(mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')})
    ];

    var lastItem = false;
    if (item.lastItem != null && item.lastItem) lastItem = true;

    return Flexible(
      flex: 1,
      child: TextFormField(
        controller: useTextEditingController.fromValue(TextEditingValue(text: item.value ?? "")),
        inputFormatters: maskTextInputFormatterList,
        // initialValue: ,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
        keyboardType: TextInputType.numberWithOptions(),
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
          print('onSaved ${item.id}:${item.label} with VALUE: [$value] is !MT [${value.isEmpty}]');
          item.setValue(value);
        },
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          // fillColor: Colors.yellow,
          isCollapsed: true,
          hintText: item.hintText,
        ),
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
  const TextInputWidget({Key key, @required this.item, this.editable = true}) : super(key: key);

  final Item item;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    var lastItem = item.lastItem != null && item.lastItem;

    return Flexible(
      flex: 2,
      child: TextFormField(
        initialValue: item.value,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
        textInputAction: lastItem ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(
          isDense: true,
          disabledBorder: InputBorder.none,
          enabled: editable,
          filled: true,
          isCollapsed: true,
          hintText: item.hintText,
          hintStyle: editable
              ? null
              : TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
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
          print('onSaved ${item.id}:${item.label} with VALUE: $value');
          item.setValue(value);
        },
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

///************************************************************************
