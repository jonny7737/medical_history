import 'package:flutter/material.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HistoryAppBar();
  @override
  Widget build(BuildContext context) {
    final Logger _l = locator();
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return AppBar(
      title: Text('Patient Medical History'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
