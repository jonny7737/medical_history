import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/category_list.dart';
import 'package:medical_history/ui/views/history/widgets/history_appbar.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final Logger _l = locator();
  String sectionName;

  Future<List<Category>> _categories;

  @override
  void initState() {
    sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    _categories = loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const HistoryAppBar(),
        body: ListView(
          children: <Widget>[
            FutureBuilder<List<Category>>(
                future: _categories,
                builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  return Column(
                    children: snapshot.data
                        .map((category) => ListTile(
                              title: Text(
                                category.title,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              subtitle: Text(
                                category.itemsString(),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ))
                        .toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Future<List<Category>> loadCategories() async {
    String jsonString = await rootBundle.loadString('assets/categories.json');
    final parsedJson = json.decode(jsonString);

    List<Category> categories = CategoriesList.fromJson(parsedJson['categories']).categories;
    return categories;

    // for (var category in categories)
    //   print('${category.name} : ${category.title} : ${category.itemsString()}');
  }
}
