import 'package:flutter/material.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_lookup_service.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/views/add_med/widgets/list_view_card.dart';

class MedsLoadedSubView extends StatelessWidget {
  final Logger _l = locator();
  final MedLookUpService model = locator();

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 2,
              left: 10,
              right: 10,
              bottom: 80,
              child: ListView.builder(
                itemCount: model.numMedsFound,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      bool editing = model.editIndex != null;
                      _l.log(
                        sectionName,
                        'TempMed clicked: $index',
                        linenumber: _l.lineNumber(StackTrace.current),
                      );
                      model.saveSelectedMed(index);
                      model.clearTempMeds();
                      model.clearNewMed();
                      _l.log(
                        sectionName,
                        'Med saved, model meds cleared, form reset',
                        linenumber: _l.lineNumber(StackTrace.current),
                      );
                      if (editing) {
                        Navigator.pop(context, model.wasMedAdded);
                        Navigator.pop(context);
                      } else
                        Navigator.pop(context, model.wasMedAdded);
                    },
                    child: ListViewCard(index: index),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 20,
              left: 60,
              right: 60,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Manufacturer not listed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  bool editing = model.editIndex != null;
                  await model.saveMedNoMfg();
                  model.clearTempMeds();
                  model.clearNewMed();
                  _l.log(
                    sectionName,
                    'Med saved, model meds cleared, form reset',
                    linenumber: _l.lineNumber(StackTrace.current),
                  );
                  if (editing) {
                    Navigator.pop(context, model.wasMedAdded);
                    Navigator.pop(context);
                  } else
                    Navigator.pop(context, model.wasMedAdded);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
