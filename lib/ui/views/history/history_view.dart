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
  final String kHistoryFormContent = 'lib/ui/views/history/form_content/categories.json';
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
    String jsonString = await rootBundle.loadString(kHistoryFormContent);
    final parsedJson = json.decode(jsonString);

    print(jsonEncode(CategoriesList.fromJson(parsedJson)));

    return CategoriesList.fromJson(parsedJson).categories;
  }

// import 'package:dart_json/dart_json.dart';

// void main() {
//   CategoriesList categoriesList = Json.deserialize(json);
//   print(categoriesList.categories.toString());
//
//   String newJson = Json.serialize(categoriesList);
//   // print(newJson);
//   categoriesList = Json.deserialize(newJson);
//   print(categoriesList.categories.toString());
// }
//   String strJson = '''{
//       "__documentation__":
//   {
//     "_0": "ALWAYS verify the json format after editing this file",
//
//     "_1": "items describe the elements of the data input forms",
//     "_2": "data input forms are laid out in 'item' order",
//     "_3": "item['lastItem'] is a mechanism for instructing the form generator to switch the keyboard to submit",
//     "_4": "item['value'] is the current saved value for this item"
//   },
//   "categories": [
//     {
//       "id": 1,
//       "name": "patient",
//       "title": "Patient identity",
//       "items": [
//         {
//           "id": 10,
//           "label": "firstname",
//           "type": "string",
//           "hintText": "Enter your first name"
//         },
//         {
//           "id": 11,
//           "label": "lastname",
//           "type": "string",
//           "hintText": "Enter your last name"
//         },
//         {
//           "id": 12,
//           "label": "dob",
//           "type": "date",
//           "hintText": "Enter your date of birth",
//           "lastItem": true
//         }
//       ]
//     },
//     {
//       "id": 2,
//       "name": "allergies",
//       "title": "All known allergies",
//       "items": []
//     },
//     {
//       "id": 3,
//       "name": "conditions",
//       "title": "Past and present conditions",
//       "items": []
//     },
//     {
//       "id": 4,
//       "name": "medications",
//       "title": "All current medications / supplements",
//       "items": []
//     },
//     {
//       "id": 5,
//       "name": "procedures",
//       "title": "Procedures / Surgeries",
//       "items": []
//     }
//   ]
// }
// ''';
}
