import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/logger_provider.dart';

final loggerProvider = ChangeNotifierProvider((_) => LoggerProvider());

class LoggerMenuWidget extends HookWidget {
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    final _lp = useProvider(loggerProvider);
    final List<String> sectionNames = _lp.listOfSectionNames();
    sectionNames.remove('MyApp');
    sectionNames.sort((a, b) => a.compareTo(b));

    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey,
          child: CBListTile('MyApp', 'MyApp'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sectionNames.length,
            itemBuilder: (BuildContext context, int index) {
              // if (index == 0) return Material();
              return CBListTile(sectionNames[index], sectionNames[index]);
            },
          ),
        ),
      ],
    );
  }
}

class CBListTile extends HookWidget {
  CBListTile(this.title, this.sectionName);
  final String title;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: GestureDetector(
        onLongPress: () => context.read(loggerProvider).removeSection(sectionName),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      activeColor: Colors.red,
      checkColor: Colors.white,
      value: useProvider(loggerProvider).isLogging(sectionName) ?? false,
      onChanged: (bool value) {
        context.read(loggerProvider).setOption(sectionName, value);
      },
    );
  }
}
