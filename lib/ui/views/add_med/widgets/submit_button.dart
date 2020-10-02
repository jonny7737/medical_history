import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/add_med/add_med_viewmodel.dart';
import 'package:medical_history/ui/views/add_med/riverpods.dart';
import 'package:sized_context/sized_context.dart';

class AddMedSubmitButton extends HookWidget {
  AddMedSubmitButton({this.formKey});

  final GlobalKey<FormState> formKey;
  final ScreenInfoViewModel _s = locator();
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final _model = useProvider(addMedViewModel);
    final _em = useProvider(errorMessageViewModel);
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    _l.log(
      sectionName,
      'Rebuilding button, FormKey ${_model.formKey != null}',
      linenumber: _l.lineNumber(StackTrace.current),
    );

    return Positioned(
      left: context.widthPct(0.30),
      right: context.widthPct(0.30),
      top: _s.isLargeScreen ? context.heightPct(0.45) : context.heightPct(0.60),
      child: RaisedButton(
        elevation: 30,
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          _model.wasTapped('submit_button');

          // Check form for errors
          formKey.currentState.save();

          // If form has no errors AND form has a new med has been set
          if (!_em.formHasErrors && _model.hasNewMed) {
            _l.log(sectionName, '#1', linenumber: _l.lineNumber(StackTrace.current));
            if (await _model.getMedInfo()) {
              _l.log(sectionName, '#2', linenumber: _l.lineNumber(StackTrace.current));
              _l.log(sectionName, 'Form Validated', linenumber: _l.lineNumber(StackTrace.current));
            } else {
              if (_s.isAndroid) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return materialAlertDialog(context, _model);
                  },
                );
              } else if (_s.isiOS) {
                _showCupertinoErrorDialog(context);
              }
            }
            // Else if form has errors OR no new med set
          } else {
            _l.log(
              sectionName,
              'FormErrors: ${_em.formHasErrors}',
              linenumber: _l.lineNumber(StackTrace.current),
            );
            _em.clearFormError();
          }
        },
        child: Text(
          'Continue',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _showCupertinoErrorDialog(BuildContext context) async {
    final _model = useProvider(addMedViewModel);

    bool networkIssue = false;
    if (_model.rxcuiComment == null) networkIssue = true;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Medication Info ERROR'),
          content: networkIssue
              ? Text(
                  'There was a problem getting the information for the medication '
                  'name and dose you provided \n\n\tA network error occurred.\n\n '
                  'Please check your internet connection and try again',
                )
              : Text(
                  'NIH had a problem getting the information for the medication '
                  'name and dose you provided \n\n\t_model.rxcuiComment\n\n '
                  'Please check the medication name and dose and try again',
                ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  AlertDialog materialAlertDialog(BuildContext context, AddMedViewModel _model) {
    final themeProvider = useProvider(themeDataProvider);

    bool networkIssue = false;
    if (_model.rxcuiComment == null) networkIssue = true;

    return AlertDialog(
      title: Text('Medication Info ERROR'),
      backgroundColor: themeProvider.isDarkTheme ? Colors.grey[600] : Colors.white,
      elevation: 20.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            if (networkIssue) Text('There was a problem getting the'),
            if (!networkIssue) Text('NIH had a problem getting the'),
            Text('information for the medication'),
            Text('name and dose you provided'),
            Text('\n\t${_model.rxcuiComment ?? 'A network error occurred.'}\n'),
            if (networkIssue) Text('Please check your internet connection and try again'),
            if (!networkIssue) Text('Please check the medication name and dose and try again'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
