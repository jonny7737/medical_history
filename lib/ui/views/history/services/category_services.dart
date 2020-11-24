import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/category_list.dart';
import 'package:medical_history/ui/views/history/models/item.dart';

class CategoryServices {
  final String kHistoryFormContent = 'lib/ui/views/history/form_content/categories.json';
  CategoriesList cat;

  Future<List<Category>> get categories async => await Future.microtask(() async {
        if (cat?.categories == null) await _loadCategories();
        return cat.categories;
      });

  Future<void> _loadCategories() async {
    final String jsonString = await rootBundle.loadString(kHistoryFormContent);
    final parsedJson = json.decode(jsonString);

    cat = CategoriesList.fromJson(parsedJson);
  }

  Future saveCategories() async {
    print('dart-2-json');
    print(jsonEncode(cat));
  }

  bool shakeIt(int id) {
    final Category c = cat.categories.firstWhere((element) => element.id == id);

    bool notShakeIt = false;
    c?.items?.forEach((Item item) {
      if (item?.value != null) notShakeIt = notShakeIt || item.value.length > 0;
    });
    return !notShakeIt;
  }
}
