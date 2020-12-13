import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medical_history/ui/views/history/models/history_viewmodel.dart';
import 'package:medical_history/ui/views/history/models/item.dart';

///************************************************************************
final historyViewModel = ChangeNotifierProvider<HistoryViewModel>((ref) => HistoryViewModel());

class RowInputWidget extends HookWidget {
  // final CategoryServices _cs = locator();

  RowInputWidget({Key key, @required this.items, @required this.categoryID}) : super(key: key);

  final List<Item> items;
  final int categoryID;

  @override
  Widget build(BuildContext context) {
    print('Building RowInput...');
    HistoryViewModel _model = useProvider(historyViewModel);

    void updateUI() {
      _model.updateUI(categoryID);
      print('updateUI[$categoryID]');
    }

    // List<Item> baseItems = _model.baseItems(categoryID);
    List<Widget> columnChildren = [];
    int nextID = categoryID * 10;

    if (_model.baseItems(categoryID) == null || _model.baseItems(categoryID).isEmpty) {
      print('JSON Error:  ExpandableInputWidget requires baseItems');
      return Container();
    }
    if (items.length != 0) {
      for (int i = 0; i < items.length; i += 2) {
        var row = Row(
          children: [
            TextInputWidget(item: items[i]),
            if (items[i + 1].type == 'date')
              DateInputWidget(item: items[i + 1], editComplete: updateUI),
            if (items[i + 1].type == 'checkbox') CheckBoxWidget(item: items[i + 1])
          ],
        );
        columnChildren.add(row);
      }
      nextID = items[items.length - 1].id + 1;
    }

    if (items.isNotEmpty) print('items[${items.length}].value[${items[items.length - 1].value}]');

    if (items.length > 0) {
      if (items[items.length - 1].value != null && items[items.length - 1].value.isNotEmpty)
        columnChildren.addAll(_model.addBaseItems(categoryID, nextID));
    } else if (items.length == 0) columnChildren.addAll(_model.addBaseItems(categoryID, nextID));

    return Column(children: columnChildren);
  }

  // List<Widget> addBaseItems(model, int categoryID, int nextID) {
  //   List<Widget> columnChildren = [];
  //   List<Widget> rowChildren = [];
  //   List<Item> newItems = [];
  //   model.baseItems(categoryID).forEach((Item base) {
  //     newItems.add(itemFromBase(base, nextID));
  //     nextID += 1;
  //   });
  //   for (int i = 0; i < newItems.length; i += 2) {
  //     rowChildren.add(TextInputWidget(item: newItems[i]));
  //     if (newItems[i + 1].type == 'date')
  //       rowChildren.add(DateInputWidget(item: newItems[i + 1]));
  //     else if (newItems[i + 1].type == 'checkbox')
  //       rowChildren.add(CheckBoxWidget(item: newItems[i + 1]));
  //     model.addItem(categoryID, newItems[i]);
  //     model.addItem(categoryID, newItems[i + 1]);
  //   }
  //   columnChildren.add(Row(children: rowChildren));
  //   return columnChildren;
  // }
  //
  // Item itemFromBase(Item baseItem, int nextID) {
  //   Item item = Item(
  //       id: nextID,
  //       categoryID: baseItem.categoryID,
  //       label: baseItem.label,
  //       type: baseItem.type,
  //       hintText: baseItem.hintText,
  //       lastItem: baseItem.lastItem);
  //   return item;
  // }
}

///************************************************************************
class DateInputWidget extends HookWidget {
  DateInputWidget({Key key, @required this.item, this.editComplete}) : super(key: key);

  final Item item;
  final Function editComplete;

  @override
  Widget build(BuildContext context) {
    List<MaskTextInputFormatter> maskTextInputFormatterList = [
      MaskTextInputFormatter(mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')})
    ];

    var lastItem = item.lastItem != null && item.lastItem;
    // if (item.lastItem != null && item.lastItem) lastItem = true;

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
          print('onEditingComplete: [$editComplete]');
          if (lastItem) SystemChannels.textInput.invokeMethod('TextInput.hide');
          if (editComplete != null) editComplete(item.categoryID);

          editComplete(item.categoryID);
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
