import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/category_list.dart';
import 'package:medical_history/ui/views/history/models/item.dart';

class CategoryServices {
  final String kHistoryFormContent = 'lib/ui/views/history/form_content/categories.json';

  final storage = FlutterSecureStorage();
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
    print('dart-2-json\n' + jsonEncode(cat));
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
    bool debug = false;
    assert(debug = true);
    if (debug) {
      print('DEBUG MODE: history data not loaded from prefs');
      return Future.value(null);
    }
    return await storage.read(key: "history_data");
  }

  void _savePrefs(String json) async {
    storage.write(key: "history_data", value: json);
  }
}
