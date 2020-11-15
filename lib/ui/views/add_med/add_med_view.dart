import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_lookup_service.dart';
import 'package:medical_history/ui/views/add_med/add_med_viewmodel.dart';
import 'package:medical_history/ui/views/add_med/riverpods.dart';
import 'package:medical_history/ui/views/add_med/widgets/add_med_form.dart';

class AddMedArguments {
  final int editIndex;

  const AddMedArguments({this.editIndex});
}

class AddMedView extends HookWidget {
  final Logger _l = locator();
  final MedLookUpService _ml = locator();

  AddMedView(this.editIndex);
  final int editIndex;

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    AddMedViewModel _model = useProvider(addMedViewModel);
    _l.initSectionPref(sectionName);

    _model.setMedForEditing(editIndex);
    _model.logEditIndex();

    _l.log(sectionName, 'Rebuilding [Edit Index: $editIndex]',
        linenumber: _l.lineNumber(StackTrace.current));

    return SafeArea(
      child: Scaffold(
        key: GlobalKey(),
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              _ml.clearTempMeds();
              _ml.clearNewMed();
              if (_model.medsLoaded) {
                _model.setMedsLoaded(false);
                _model.formKey.currentState?.reset();
              } else
                Navigator.pop(context, _model.wasMedAdded);
            },
          ),
          actions: <Widget>[
            IconButton(
                color: Colors.white,
                tooltip: 'Add a new Doctor',
                icon: ImageIcon(
                  AssetImage('assets/doctor.png'),
                ),
                onPressed: () {
                  _l.log(sectionName, 'Add a new Doctor',
                      linenumber: _l.lineNumber(StackTrace.current));
                  Navigator.pushNamed(context, addDoctorRoute);
                }),
          ],
          title: Text('Add a Medication'),
          centerTitle: true,
        ),
        body: AddMedForm(),
      ),
    );
  }
}
