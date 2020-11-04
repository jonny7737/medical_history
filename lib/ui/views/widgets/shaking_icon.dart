import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ShakingIcon extends StatefulWidget {
  /// Icon to shake
  final IconData icon;

  /// Size parameter passed to Icon constructor
  final double size;

  /// Color parameter passed to Icon constructor
  final Color color;

  /// Enable / Disable shake to support dynamic UI
  /// Default to true
  final bool shake;

  /// Horizontal or Vertical shake.  Default to Horizontal shake
  final bool horizontalShake;

  /// Frequency to repeat the shake in seconds
  final int secondsToRepeat;

  /// [ShakingTitleIcon(this.icon, {@required this.size, this.color, this.horizontalShake})]
  ///
  ///     1. [icon]: IconData (Icons.) for icon to shake.
  ///
  ///     2. [horizontalShake]: Shake horizontally if true, otherwise shake vertically.
  ///
  ///
  /// Example:
  /// ```dart
  ///     ShakingTitleIcon(Icons.verified_user, size: 32, horizontalShake: false),
  ///
  /// ```
  ///
  ShakingIcon(
    this.icon, {
    @required this.size,
    this.color,
    this.shake = true,
    this.horizontalShake = true,
    this.secondsToRepeat = 0,
  });

  @override
  _ShakingIconState createState() => _ShakingIconState();
}

class _ShakingIconState extends State<ShakingIcon> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Timer timer;
  final Random rng = Random();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (_, child) {
        return Transform(
          transform: Matrix4.translation(_shake()),
          child: child,
        );
      },
      child: Icon(
        widget.icon,
        size: widget.size,
        color: widget.color,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    likeAPolaroidCamera();
  }

  int nextRndInt({int min = 0, @required int max}) => min + rng.nextInt(max - min);

  void likeAPolaroidCamera() {
    if (widget.shake) {
      waitForIt();
      if (widget.secondsToRepeat > 0)
        timer = Timer.periodic(Duration(seconds: widget.secondsToRepeat), (_) {
          if (ExpandableController.of(context).expanded) return;
          waitForIt();
        });
    }
  }

  void waitForIt() {
    Future.delayed(Duration(seconds: nextRndInt(min: 2, max: 7))).then((_) {
      if (!mounted) return;
      animationController.reset();
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Vector3 _shake() {
    /// 10.0 is the number of oscillations (how many wiggles)
    ///  8.0 is how wide is your wiggle
    double offset = sin(animationController.value * pi * 10.0) * 8;
    if (widget.horizontalShake) return Vector3(offset, offset, 0.0);
    return Vector3(0.0, offset, 0.0);
  }
}
