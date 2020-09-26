import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_history/ui/views/keygen/painter.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/secure_storage.dart';
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
      SystemSound.play(SystemSoundType.click);
      Navigator.pop(context);
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
}
