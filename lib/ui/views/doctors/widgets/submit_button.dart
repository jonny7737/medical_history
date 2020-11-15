import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/doctors/doctors_viewmodel.dart';
import 'package:sized_context/sized_context.dart';

class PositionedSubmitButton extends StatelessWidget {
  PositionedSubmitButton({Key key, @required GlobalKey<FormState> formKey})
      : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final DoctorsViewModel _model = locator();
  final ScreenInfoViewModel _screen = locator();
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    return Positioned(
      left: context.widthPct(0.30),
      right: context.widthPct(0.30),
      top: _screen.isLargeScreen ? context.heightPct(0.25) : context.heightPct(0.30),
      child: RaisedButton(
        elevation: 30,
        color: Theme.of(context).primaryColor,
        onPressed: () {
          _l.log(sectionName, 'pressed');
          SystemChannels.textInput.invokeMethod('TextInput.hide');

          /// Check form for errors by calling the field onSave function
          /// I didn't use the validate function because I want custom error UXs
          _formKey.currentState.save();

          // If form has no errors AND form has a new med has been set
          if (!_model.formHasErrors && _model.hasNewDoctor) {
            _model.saveDoctor();
            _formKey.currentState.reset();
            _model.clearNewDoctor();
            _l.log(sectionName, 'Form Validated', linenumber: _l.lineNumber(StackTrace.current));
            Navigator.pop(context);

            // If form has errors OR no new med set
          } else {
            _l.log(sectionName, 'FormErrors: ${_model.formHasErrors}',
                linenumber: _l.lineNumber(StackTrace.current));
            _model.clearFormError();
          }
        },
        child: Text(
          'Continue',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
