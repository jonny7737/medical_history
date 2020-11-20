import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/category_list.dart';

class HistoryViewModel with ChangeNotifier {
  final String kHistoryFormContent = 'lib/ui/views/history/form_content/categories.json';
  String sectionName;

  Future<List<Category>> categories;

  HistoryViewModel() {
    categories = loadCategories();
  }

  Future<List<Category>> loadCategories() async {
    String jsonString = await rootBundle.loadString(kHistoryFormContent);
    final parsedJson = json.decode(jsonString);

    return CategoriesList.fromJson(parsedJson).categories;
  }

  Future saveCategories() async {
    Future.delayed(Duration(seconds: 2)).then((value) => print('Data saved...'));
  }
}
