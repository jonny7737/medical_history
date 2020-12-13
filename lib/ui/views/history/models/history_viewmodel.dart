import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/widgets.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/item.dart';
import 'package:medical_history/ui/views/history/services/category_services.dart';
import 'package:medical_history/ui/views/history/widgets/form_widgets.dart';

class HistoryViewModel with ChangeNotifier {
  final CategoryServices _cs = locator();

  String sectionName;

  Future<List<Category>> get categories async => _cs.categories;

  List<Item> baseItems(int id) {
    return _cs.baseItems(id);
  }

  void addItem(int id, Item newItem) {
    _cs.addItem(id, newItem);
    // notifyListeners();
  }

  void saveCategories() {
    _cs.saveCategories();
    notifyListeners();
    return;
  }

  void updateUI(int categoryID) {
    print('[$categoryID] updateUI!!!!');
    notifyListeners();
  }

  List<Widget> addBaseItems(int categoryID, int nextID) {
    List<Widget> columnChildren = [];
    List<Widget> rowChildren = [];
    List<Item> newItems = [];
    baseItems(categoryID).forEach((Item base) {
      newItems.add(itemFromBase(base, nextID));
      nextID += 1;
    });
    for (int i = 0; i < newItems.length; i += 2) {
      rowChildren.add(TextInputWidget(item: newItems[i]));
      if (newItems[i + 1].type == 'date')
        rowChildren.add(DateInputWidget(item: newItems[i + 1], editComplete: updateUI));
      else if (newItems[i + 1].type == 'checkbox')
        rowChildren.add(CheckBoxWidget(item: newItems[i + 1]));
      addItem(categoryID, newItems[i]);
      addItem(categoryID, newItems[i + 1]);
    }
    columnChildren.add(Row(children: rowChildren));
    return columnChildren;
  }

  Item itemFromBase(Item baseItem, int nextID) {
    Item item = Item(
        id: nextID,
        categoryID: baseItem.categoryID,
        label: baseItem.label,
        type: baseItem.type,
        hintText: baseItem.hintText,
        lastItem: baseItem.lastItem);
    return item;
  }
}
