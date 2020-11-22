import 'dart:math';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/views/history/services/category_services.dart';
import 'package:medical_history/ui/views/widgets/shaking_icon.dart';

class RowTitleWidget extends HookWidget {
  final CategoryServices _cs = locator();
  final String title;
  final int id;
  final double angle = -pi;

  RowTitleWidget(this.title, this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(duration: Duration(milliseconds: 400));
    final isMounted = useIsMounted();

    Future.delayed(Duration(milliseconds: 600)).then((_) {
      if (!isMounted()) return;
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
            ShakingIcon(Icons.verified_user, shakeIt: shakeIt, secondsToRepeat: 30),
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
                  color: Colors.black, horizontalShake: false, shake: false),
            )
          ],
        ),
        Divider(height: 15, thickness: 2, color: Colors.grey),
      ],
    );
  }

  /// Function passed to ShakingIcon to determine shake flag dynamically
  bool shakeIt(bool shake) {
    bool shakeIt = shake;
    if (id != null) {
      shakeIt = _cs.shakeIt(id);
    }
    return shakeIt;
  }
}
