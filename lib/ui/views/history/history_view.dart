import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/category_list.dart';
import 'package:medical_history/ui/views/history/widgets/expandable_list_tile.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final Logger _l = locator();
  String sectionName;

  Future<List<Category>> _categories;

  @override
  Widget build(BuildContext context) {
    _l.log(sectionName, '(Re-)Building', linenumber: _l.lineNumber(StackTrace.current));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Patient Medical History')),
        body: FutureBuilder<List<Category>>(
            future: _categories,
            builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              return Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: snapshot.data.map((category) => ExpandableListTile(category)).toList(),
                ),
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    _categories = loadCategories();
    super.initState();
  }

  Future<List<Category>> loadCategories() async {
    String jsonString = await rootBundle.loadString('assets/categories.json');
    final parsedJson = json.decode(jsonString);
    List<Category> categories = CategoriesList.fromJson(parsedJson['categories']).categories;
    return categories;
  }
}
