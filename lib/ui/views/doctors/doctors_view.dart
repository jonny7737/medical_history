import 'package:flutter/material.dart';

import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/doctor_data.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/doctors/doctors_viewmodel.dart';

class DoctorsView extends StatelessWidget {
  final DoctorsViewModel _model = locator();
  final Logger _l = locator();

  @override
  Widget build(BuildContext context) {
    final sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);
    _l.log(sectionName, 'Building');

    if (_model.numberOfDoctors == 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushNamed(context, addDoctorRoute);
      });
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context, _model.addedDoctors);
            },
          ),
          title: Text('Manage your Doctors'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              tooltip: "Add a new doctor",
              icon: Icon(Icons.add_circle, color: Colors.white),
              padding: EdgeInsets.all(0.0),
              onPressed: () async {
                Navigator.pushNamed(context, addDoctorRoute);
              },
            ),
          ],
        ),
        body: DoctorListView(),
      ),
    );
  }
}

class DoctorListView extends StatefulWidget {
  @override
  _DoctorListViewState createState() {
    return _DoctorListViewState();
  }
}

class _DoctorListViewState extends State<DoctorListView> {
  final Logger _l = locator();
  DoctorsViewModel _model = locator();
  final String sectionName = 'DoctorsView';
  @override
  initState() {
    _model.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    _model.removeListener(update);
    super.dispose();
  }

  void update() {
    _l.log(
      sectionName,
      'DoctorViewModel reported an update',
      linenumber: _l.lineNumber(StackTrace.current),
    );
    setState(() {});
  }

  DoctorData getDoctorByName(String name) {
    _model.getDoctorByName(name);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _model.numberOfDoctors,
      itemBuilder: (context, index) {
        DoctorData doctorData = _model.doctorByIndex(index);
        // getDoctorByName(doctorData.name);
        return Dismissible(
          key: UniqueKey(),
          dismissThresholds: const {
            DismissDirection.endToStart: 0.7,
            DismissDirection.startToEnd: 0.6,
          },
          background: Container(
              alignment: Alignment.centerLeft,
              color: Colors.purple,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text(
                  'Edit',
                  style: TextStyle(),
                ),
              )),
          secondaryBackground: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: ListTile(
                trailing: Icon(Icons.delete_forever),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Delete',
                    style: TextStyle(),
                  ),
                ),
              )),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              _model.setActiveDoctor(index);

              /// edit item : launch edit function from here
              Navigator.pushNamed(context, addDoctorRoute);
              return false;
            }

            /// delete
            return true;
          },
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              /// Handle delete operations here
              _model.deleteDoctor(index);
            } else if (direction == DismissDirection.startToEnd) {
              /// This never happens because confirmDismiss returns false
              /// for startToEnd swipe, therefore the item is not dismissed
              print('EDIT');
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 6),
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                child: Image.asset('assets/doctor.png'),
              ),
              title: Text(
                '${doctorData.name}',
                style: TextStyle(color: Colors.black),
              ),
              trailing: Text(
                '${doctorData.phone}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 4,
        );
      },
    );
  }
}
