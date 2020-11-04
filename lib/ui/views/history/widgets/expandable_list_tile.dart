import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:medical_history/ui/views/history/widgets/input_form_w.dart';
import 'package:medical_history/ui/views/history/widgets/row_title_w.dart';

class ExpandableListTile extends StatelessWidget {
  const ExpandableListTile(this.category, {Key key}) : super(key: key);

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
            header: RowTitleWidget(category.title + " : " + category.id.toString()),
            expanded: InputForm(category.items),
          ),
        ),
      ),
    );
  }
}
