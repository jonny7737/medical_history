import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/category_list.dart';
import 'package:medical_history/ui/views/history/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryServices {
  final String kHistoryFormContent = 'lib/ui/views/history/form_content/categories.json';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CategoriesList cat;

  Future<List<Category>> get categories async => await Future.microtask(() async {
        if (cat?.categories == null) await _loadCategories();
        return cat.categories;
      });

  Future<void> _loadCategories() async {
    String jsonString = await _loadPrefs();
    if (jsonString == null || jsonString.isEmpty)
      jsonString = await rootBundle.loadString(kHistoryFormContent);
    final parsedJson = json.decode(jsonString);

    cat = CategoriesList.fromJson(parsedJson);
  }

  Future saveCategories() async {
    print('dart-2-json');
    print(jsonEncode(cat));
    _savePrefs(jsonEncode(cat));
  }

  bool shakeIt(int id) {
    final Category c = cat.categories.firstWhere((element) => element.id == id);

    bool notShakeIt = false;
    c?.items?.forEach((Item item) {
      if (item?.value != null) notShakeIt = notShakeIt || item.value.length > 0;
    });
    return !notShakeIt;
  }

  Future<String> _loadPrefs() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString("history_data");
  }

  void _savePrefs(String json) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString("history_data", json);
  }
}
