import 'dart:convert';
import 'dart:async' show Future;
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/models/category_list.dart';
import 'package:medical_history/ui/views/history/widgets/input_form_w.dart';
import 'package:medical_history/ui/views/history/widgets/row_title_w.dart';

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
    _l.log(sectionName, '(Re-)Building', linenumber: _l.lineNumber(StackTrace.current));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Patient Medical History')),
        body: FutureBuilder<List<Category>>(
            future: _categories,
            builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: snapshot.data.map((category) => _ListTileWidget(category)).toList(),
                ),
              );
            }),
      ),
    );
  }

  Future<List<Category>> loadCategories() async {
    _l.log(sectionName, '(Re)Loading Categories', linenumber: _l.lineNumber(StackTrace.current));
    String jsonString = await rootBundle.loadString('assets/categories.json');

    _l.log(sectionName, '$jsonString', linenumber: _l.lineNumber(StackTrace.current));

    final parsedJson = json.decode(jsonString);

    List<Category> categories = CategoriesList.fromJson(parsedJson['categories']).categories;
    return categories;
  }
}

class _ListTileWidget extends StatelessWidget {
  const _ListTileWidget(this.category, {Key key}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return ExpandableTheme(
      data: ExpandableThemeData(
        scrollAnimationDuration: Duration(milliseconds: 400),
        animationDuration: Duration(milliseconds: 400),
        tapBodyToCollapse: true,
        hasIcon: false,
      ),
      child: ExpandableNotifier(
        child: ScrollOnExpand(
          child: ExpandablePanel(
            header: RowTitleWidget(category.title),
            expanded: InputForm(category.items),
          ),
        ),
      ),
    );
  }
}
