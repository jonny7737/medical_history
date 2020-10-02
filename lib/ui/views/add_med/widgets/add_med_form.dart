import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/ui/views/add_med/add_med_viewmodel.dart';
import 'package:medical_history/ui/views/add_med/widgets/error_message_viewmodel.dart';
import 'package:medical_history/ui/views/add_med/riverpods.dart';
import 'package:sized_context/sized_context.dart';

import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/views/add_med/widgets/add_med_field.dart';
import 'package:medical_history/ui/views/add_med/widgets/editable_dropdown.dart';
import 'package:medical_history/ui/views/add_med/widgets/submit_button.dart';
import 'package:medical_history/ui/views/widgets/drop_down_formfield.dart';
import 'package:medical_history/ui/views/widgets/stack_modal_blur.dart';

class AddMedForm extends HookWidget {
  final Logger _l = locator();
  final ScreenInfoViewModel _s = locator();

  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);

  static final _formKey = GlobalKey<FormState>();
  final FocusNode f1 = FocusNode();
  final FocusNode f2 = FocusNode();
  final FocusNode f3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Logger _l = locator();
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    final _model = useProvider(addMedViewModel);
    final _em = useProvider(errorMessageViewModel);

    _l.initSectionPref(sectionName);

    _model.setFormKey(_formKey);
    if (_s.isSmallScreen) _model.formScrollController = _scrollController;

    if (_model.medsLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateToMedsLoadedView(context, sectionName);
      });

      _l.log(sectionName, 'Meds Loaded...', linenumber: _l.lineNumber(StackTrace.current));
    }

    _l.log(
      sectionName,
      'Rebuilding Form [${_model.newMedName}] [FormKey ${_formKey != null}]',
      linenumber: _l.lineNumber(StackTrace.current),
    );

    return SingleChildScrollView(
      controller: _scrollController,
      child: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(height: context.heightPct(1)),
            AddMedField(
              index: 0,
              focusNode: f1,
              hint: 'Enter medication name',
              fieldName: 'name',
              onSave: (value) => setErrorMessage(_em, _model.onFormSave('name', value), 'name'),
            ),
            AddMedField(
              index: 1,
              focusNode: f2,
              hint: 'Enter medication dose (eg 10mg)',
              fieldName: 'dose',
              onSave: (value) => setErrorMessage(_em, _model.onFormSave('dose', value), 'dose'),
            ),
            EditableDropdownWidget(
              index: 2,
              focusNode: f3,
              fieldName: 'frequency',
              onSave: (value) =>
                  setErrorMessage(_em, _model.onFormSave('frequency', value), 'frequency'),
            ),
            buildDoctorDropdown(context, _model, sectionName),
            AddMedSubmitButton(formKey: _formKey),
            if (_model.isBusy || _model.medsLoaded) const StackModalBlur(),
//          if (_model.medsLoaded) ,
          ],
        ),
      ),
    );
  }

  void navigateToMedsLoadedView(BuildContext context, String sectionName) async {
    _l.log(sectionName, 'Navigating to MedsLoaded');
    bool medAdded = await Navigator.pushNamed(context, medsLoadedRoute);
    _l.log(sectionName, 'Med loading completed.. Med added: $medAdded',
        linenumber: _l.lineNumber(StackTrace.current));
  }

  nextButtonPressed(String fieldName) {
    switch (fieldName) {
      case 'name':
        break;
      case 'dose':
        break;
      case 'frequency':
        break;
    }
  }

  setErrorMessage(ErrorMessageViewModel em, bool saved, String fieldName) {
    if (saved)
      em.setFormError(false);
    else {
      em.showError(fieldName);
      em.setFormError(true);
    }
    return null;
  }

  Positioned buildDoctorDropdown(BuildContext context, AddMedViewModel _model, String sectionName) {
    return Positioned(
      top: 30 + 3 * 80.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0.0, 5.0),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(horizontal: context.widthPct(0.10)),
        alignment: Alignment.center,
        width: context.widthPct(0.80),
        child: Container(
          child: DropDownFormField(
            contentPadding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            filled: false,
            titleText: null,
            errorText: null,
            hintText: 'Please choose one',
            value: _model.fancyDoctorName,
            onSaved: (value) {
              _l.log(sectionName, 'onSaved: $value', linenumber: _l.lineNumber(StackTrace.current));
              _model.onFormSave('doctor', value);
            },
            onChanged: (value) {
              _l.log(sectionName, 'onChanged: $value',
                  linenumber: _l.lineNumber(StackTrace.current));
              _model.onFormSave('doctor', value);
            },
            dataSource: _model.doctorsForDropDown(),
            textField: 'display',
            valueField: 'value',
          ),
        ),
      ),
    );
  }
}
