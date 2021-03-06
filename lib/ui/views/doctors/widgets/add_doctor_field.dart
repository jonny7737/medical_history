import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/doctors/doctors_viewmodel.dart';
import 'package:medical_history/ui/views/doctors/widgets/error_msg_w.dart';
import 'package:sized_context/sized_context.dart';

class AddDoctorField extends StatefulWidget {
  AddDoctorField({Key key, @required int index, String hint, String fieldName})
      : _index = 30 + index * 80.0,
        _hint = hint,
        _fieldName = fieldName,
        super(key: key);

  final double _index;
  final String _hint;
  final String _fieldName;
  final String sectionName = 'AddDoctorField';

  @override
  _AddDoctorFieldState createState() => _AddDoctorFieldState();
}

class _AddDoctorFieldState extends State<AddDoctorField> {
  final DoctorsViewModel _model = locator();
  final Logger _l = locator();

  final TextEditingController textEditingController = TextEditingController();
  List<MaskTextInputFormatter> maskTextInputFormatterList;
  TextInputType _keyboardType;

  String _initialValue;
  String sectionName;

  @override
  void initState() {
    sectionName = widget.sectionName;
    _l.initSectionPref(sectionName);
    if (widget._fieldName == 'phone') {
      _initialValue = _model.activeDoctorPhone;
      maskTextInputFormatterList = [
        MaskTextInputFormatter(mask: "(###) ###-####", filter: {"#": RegExp(r'[0-9]')})
      ];
      _keyboardType = TextInputType.phone;
    } else {
      _initialValue = _model.activeDoctorName;
      maskTextInputFormatterList = null;
      _keyboardType = TextInputType.text;
    }

    textEditingController.text = _initialValue;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _l.log(sectionName, 'Executing build: field # ${widget._fieldName}',
        linenumber: _l.lineNumber(StackTrace.current));

    return Positioned(
      top: widget._index,
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
            borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: context.widthPct(0.10)),
        alignment: Alignment.center,
        width: context.widthPct(kFieldWidthPercent),
        child: Stack(children: <Widget>[
          TextFormField(
            controller: textEditingController,
            inputFormatters: maskTextInputFormatterList,
            keyboardType: _keyboardType,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget._hint,
              hintStyle: TextStyle(color: Colors.grey[700]),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            // The validator receives the text that the user has entered.
            //validator: _validator,
            onSaved: (String value) {
              _model.onFormSave(widget._fieldName, value);
            },
          ),
          DoctorErrorMsgWidget(error: widget._fieldName),
        ]),
      ),
    );
  }
}
