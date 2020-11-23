import 'dart:math';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/views/history/services/category_services.dart';
import 'package:shaking_icon/shaking_icon.dart';

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

    /// Function passed to ShakingIcon to determine shake flag dynamically.
    /// Shake parameter is the value of the shake parameter passed to the ShakingIcon widget.
    /// It is included for flexibility.
    bool shakeIt(bool shake) {
      /// Shake based on shake flag originally set for ShakingIcon
      bool shakeIt = shake;

      /// Override with with rules from CategoryServices if id is set
      if (id != null) shakeIt = _cs.shakeIt(id);

      /// Ignore everything and set to no shaking if ExpandablePanel is expanded
      if (ExpandableController.of(context).expanded) shakeIt = false;
      return shakeIt;
    }

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
}
