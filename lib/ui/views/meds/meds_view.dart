import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/views/add_med/add_med_view.dart';
import 'package:medical_history/ui/views/meds/meds_viewmodel.dart';
import 'package:medical_history/ui/views/meds/widgets/detail_card_w.dart';
import 'package:medical_history/ui/views/meds/widgets/list_view_card.dart';
import 'package:medical_history/ui/views/widgets/stack_modal_blur.dart';
import 'package:sized_context/sized_context.dart';

final medsViewModel = ChangeNotifierProvider<MedsViewModel>((ref) {
  final user = ref.watch(userProvider);
  return MedsViewModel(
    user: user,
  );
});

class MedsView extends HookWidget {
  final Logger _l = locator();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    /// TODO: Need to add encryption to Meds hive box.
    final MedsViewModel _model = useProvider(medsViewModel);
    final themeProvider = useProvider(themeDataProvider);

    _l.log(sectionName, 'Meds available: ${_model.numberOfMeds}',
        linenumber: _l.lineNumber(StackTrace.current));

    _model.setBottoms(context);

    // if (_model.numberOfMeds == 0)
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //     _model.setActiveMedIndex(null);
    //     bool result = await Navigator.pushNamed<bool>(context, addMedRoute);
    //     if (result != null && result) {
    //       _model.modelDirty(true);
    //     }
    //   });
    //
    return SafeArea(
      child: Material(
        elevation: 10,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: themeProvider.isDarkTheme ? Colors.black87 : null,
            title: Center(
              child: Container(
                width: context.widthPct(0.65),
                child: Text(
                  'Medication for\n${_model.userName}',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                tooltip: "Add a new medication",
                icon: Icon(Icons.add_circle, color: Colors.white),
                padding: EdgeInsets.all(0.0),
                onPressed: () async {
                  _l.log(sectionName, 'AddMed button clicked',
                      linenumber: _l.lineNumber(StackTrace.current));
                  _model.setActiveMedIndex(null);
                  bool result = await Navigator.pushNamed<bool>(context, addMedRoute);
                  if (result != null && result) {
                    _model.modelDirty(true);
                  }
                },
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              // This is the BACKGROUND image
              Positioned(
                top: context.heightPct(0.20),
                left: (context.widthPct(0.15)),
                child: Image.asset(
                  'assets/drug-2.png',
                  width: context.widthPct(0.70),
                ),
              ),
              ListView.builder(
                itemCount: _model.numberOfMeds,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _model.setActiveMedIndex(index);
                      _model.showDetailCard();
                    },
                    child: Dismissible(
                      key: UniqueKey(),
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.5,
                        DismissDirection.startToEnd: 0.5,
                      },
                      background: const Background(),
                      secondaryBackground: const SecondaryBackground(),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          /// Start edit process here and return false to not dismiss
                          ///
                          navigateToAddMed(context, index, _model);
                          return false;
                        }

                        /// true triggers a delete
                        return true;
                      },
                      onDismissed: (DismissDirection direction) {
                        return handleDismiss(context, _model, direction, index);
                      },
                      child: Container(
                        width: context.widthPx,
                        child: ListViewCard(index: index),
                      ),
                    ),
                  );
                },
              ),
              if (_model.detailCardVisible) const StackModalBlur(),
              DetailCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// navigateToAddMed is done this way to eliminate an exception.
  ///   If the navigation is not done here, the Dismissible AnimationController
  ///   throws an exception for calling reverse() after dispose()
  ///
  Future navigateToAddMed(BuildContext context, int index, MedsViewModel _model) async {
    bool result = await Navigator.pushNamed<bool>(
      context,
      addMedRoute,
      arguments: AddMedArguments(editIndex: index),
    );
    if (result != null && result) {
      _model.modelDirty(true);
    }
  }

  handleDismiss(BuildContext context, MedsViewModel model, DismissDirection direction, int index) {
    // Get a reference to the swiped item
    final swipedMed = model.getMedAt(index);

    // Remove it from the list
    model.delete(swipedMed);

    String action;
    if (direction == DismissDirection.endToStart)
      action = "Deleted";
    else
      action = "Edited";

    _scaffoldKey.currentState
        .showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(_scaffoldKey.currentContext).primaryColor,
            content: Text(
              '$action. Do you want to undo?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
                label: "Undo",
                textColor: Colors.yellowAccent,
                onPressed: () async {
                  // Deep copy the deleted medication
                  final newMed = swipedMed.copyWith();
                  // Save the newly created medication
                  if (newMed.mfg.contains('Unknown')) await model.setDefaultMedImage(newMed.rxcui);
                  model.save(newMed);
                }),
          ),
        )
        .closed
        .then((reason) {
      if (reason != SnackBarClosedReason.action) {
        // The SnackBar was dismissed by some other means
        // other than clicking of action button
      }
    });
  }
}

class Background extends StatelessWidget {
  const Background({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        color: Theme.of(context).primaryColor,
        child: ListTile(
          leading: Icon(Icons.edit),
          title: Text(
            'Edit',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
  }
}

class SecondaryBackground extends StatelessWidget {
  const SecondaryBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: ListTile(
          trailing: Icon(Icons.delete_forever),
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
