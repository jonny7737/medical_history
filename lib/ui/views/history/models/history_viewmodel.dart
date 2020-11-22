import 'package:flutter/foundation.dart' hide Category;
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/services/category_services.dart';

class HistoryViewModel with ChangeNotifier {
  final CategoryServices _cs = locator();

  String sectionName;

  Future<List<Category>> get categories async => await _cs.categories;

  Future saveCategories() async {
    await _cs.saveCategories();
    notifyListeners();
    return;
  }
}
