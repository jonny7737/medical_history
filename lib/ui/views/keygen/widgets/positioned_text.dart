import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';

class PositionedText1 extends StatelessWidget {
  const PositionedText1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.heightPct(0.05),
      left: context.widthPct(0.10),
      right: context.widthPct(0.10),
      child: Center(
        child: Text(
          'Draw a random pattern.',
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class PositionedText2 extends StatelessWidget {
  const PositionedText2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.heightPct(0.10),
      left: context.widthPct(0.10),
      right: context.widthPct(0.10),
      child: Center(
        child: Text(
          'You do not need to remember it.',
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
