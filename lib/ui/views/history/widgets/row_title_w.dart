import 'dart:math';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:medical_history/ui/views/history/widgets/shaking_icon.dart';

class RowTitleWidget extends StatefulWidget {
  final String title;

  RowTitleWidget(this.title, {Key key}) : super(key: key);

  @override
  _RowTitleWidgetState createState() => _RowTitleWidgetState();
}

class _RowTitleWidgetState extends State<RowTitleWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double angle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    if (ExpandableController.of(context).expanded) {
      angle = -pi;
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return Column(
      children: [
        Row(
          children: [
            ShakingIcon(Icons.verified_user, size: 36, secondsToRepeat: 30),
            SizedBox(width: 10, height: 40),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * angle,
                  child: child,
                );
              },
              child: ShakingIcon(Icons.arrow_downward_rounded,
                  size: 36, color: Colors.black, horizontalShake: false, shake: false),
            )
          ],
        ),
        Divider(height: 15, thickness: 2, color: Colors.grey),
      ],
    );
  }
}
