import 'dart:math';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medical_history/ui/views/widgets/shaking_icon.dart';

class RowTitleWidget extends HookWidget {
  final String title;
  final double angle = -pi;

  RowTitleWidget(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(duration: Duration(milliseconds: 400));

    Future.delayed(Duration(milliseconds: 600)).then((_) {
      if (ExpandableController.of(context).expanded) {
        _controller.forward();
      } else if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    return Column(
      children: [
        Row(
          children: [
            ShakingIcon(Icons.verified_user, size: 36, secondsToRepeat: 30),
            SizedBox(width: 10, height: 40),
            Expanded(
              child: Text(
                title,
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
              child: ShakingIcon('assets/003-pointer.png',
                  size: 36, color: Colors.black, horizontalShake: false, shake: false),
            )
          ],
        ),
        Divider(height: 15, thickness: 2, color: Colors.grey),
      ],
    );
  }
}
