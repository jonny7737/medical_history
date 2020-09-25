import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/home/home_viewmodel.dart';
import 'package:medical_history/ui/views/home/widgets/custom_drawer.dart';
import 'package:medical_history/ui/views/home/widgets/home_view_widget.dart';

final homeViewModel = ChangeNotifierProvider((ref) => HomeViewModel());

class HomeView extends HookWidget {
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);
    _l.log(sectionName, '(re)building', linenumber: _l.lineNumber(StackTrace.current));

    return CustomDrawer(child: HomeViewWidget());
  }
}
