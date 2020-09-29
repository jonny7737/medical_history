import 'package:flutter/material.dart';
import 'package:medical_history/ui/views/keygen/painter.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sized_context/sized_context.dart';

class KeyGenView extends StatefulWidget {
  @override
  _KeyGenViewState createState() => new _KeyGenViewState();
}

class _KeyGenViewState extends State<KeyGenView> {
  SecureStorage _ss = locator();
  GestureDetector touch;
  CustomPaint canvas;
  Painter fingerPainter;

  void panStart(DragStartDetails details) {
    fingerPainter.startStroke(details.localPosition);
  }

  void panUpdate(DragUpdateDetails details) {
    fingerPainter.appendStroke(details.localPosition);
    if (_ss.ccBuilder(details.hashCode.remainder(255))) {
      // SystemSound.play(SystemSoundType.click);
      alertUser().show().then((_) => Navigator.pop(context));
    }
  }

  void panEnd(DragEndDetails details) {
    fingerPainter.endStroke();
  }

  @override
  void initState() {
    super.initState();
    fingerPainter = Painter(Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    touch = new GestureDetector(
      onPanStart: panStart,
      onPanUpdate: panUpdate,
      onPanEnd: panEnd,
    );

    canvas = new CustomPaint(
      painter: fingerPainter,
      child: touch,
    );

    Container container = Container(
      padding: EdgeInsets.all(20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Card(
          elevation: 10.0,
          child: canvas,
        ),
      ),
    );

    return new Scaffold(
      appBar: AppBar(title: Text("Draw a random pattern")),
      backgroundColor: Colors.yellow[600],
      body: Stack(
        children: [
          container,
          Positioned(
              top: context.heightPct(0.05),
              left: context.widthPct(0.10),
              right: context.widthPct(0.10),
              child: Center(
                  child: Text('Draw any random patter you like.',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
          Positioned(
              top: context.heightPct(0.10),
              left: context.widthPct(0.10),
              right: context.widthPct(0.10),
              child: Center(
                  child: Text('You do not need to remember it.',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }

  Alert alertUser() {
    return Alert(
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          color: Theme.of(context).primaryColor,
          child: Text(
            "Continue",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        )
      ],
      style: alertStyle(),
      type: AlertType.success,
      context: context,
      title: "SUCCESS!!!",
      desc: "You have successfully created your document security keys.",
      alertAnimation: fadeAlertAnimation,
    );
  }

  AlertStyle alertStyle() {
    double alertWidth = context.widthPct(1.0);
    return AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 500),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.yellow, // TODO: need a grey option here for light mode
        fontWeight: FontWeight.bold,
      ),
      constraints: BoxConstraints.expand(width: alertWidth),
      overlayColor: Color(0x75000000),
      backgroundColor: Colors.grey[600],
      alertElevation: 10,
      alertAlignment: Alignment.center,
    );
  }

  Widget fadeAlertAnimation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
