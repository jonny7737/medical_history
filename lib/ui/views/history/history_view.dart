import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/widgets/expandable_list_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/ui/views/history/models/history_viewmodel.dart';

final historyViewModel = ChangeNotifierProvider<HistoryViewModel>((ref) => HistoryViewModel());

class HistoryView extends HookWidget {
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    HistoryViewModel _model = useProvider(historyViewModel);

    _model.sectionName = this.runtimeType.toString();
    _l.initSectionPref(_model.sectionName);
    _l.log(_model.sectionName, '(Re-)Building', linenumber: _l.lineNumber(StackTrace.current));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Patient Medical History')),
        body: FutureBuilder<List<Category>>(
            future: _model.categories,
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
}
