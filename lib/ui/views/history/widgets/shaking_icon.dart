import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ShakingIcon extends StatefulWidget {
  /// Icon to shake
  final IconData icon;

  /// Horizontal or Vertical shake.  Default to Horizontal shake
  final bool horizontalShake;

  /// Frequency to repeat the shake in seconds
  final int secondsToRepeat;

  /// Size parameter passed to Icon constructor
  final double size;

  /// Color parameter passed to Icon constructor
  final Color color;

  /// Enable / Disable shake to support dynamic UI
  /// Default to true
  final bool shake;

  /// [ShakingTitleIcon({@required this.icon, @required this.horizontalShake})]
  ///
  ///     1. [icon]: IconData (Icons.) for icon to shake.
  ///
  ///     2. [horizontalShake]: Shake horizontally if true, otherwise shake vertically.
  ///
  ///
  /// Example:
  /// ```dart
  ///     ShakingTitleIcon(icon: Icons.verified_user, horizontalShake: true),
  ///
  /// ```
  ///
  ShakingIcon({
    @required this.icon,
    @required this.size,
    this.color,
    this.horizontalShake = true,
    this.secondsToRepeat = 0,
    this.shake = true,
  });

  @override
  _ShakingIconState createState() => _ShakingIconState();
}

class _ShakingIconState extends State<ShakingIcon> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  Timer timer;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController);

    if (widget.shake) {
      Random rng = Random();
      Future.delayed(Duration(seconds: rng.nextInt(5))).then((_) {
        if (!mounted) return;
        animationController.reset();
        animationController.forward();
      });

      if (widget.secondsToRepeat > 0)
        timer = Timer.periodic(Duration(seconds: widget.secondsToRepeat), (Timer _) {
          if (ExpandableController.of(context).expanded) return;
          Future.delayed(Duration(seconds: rng.nextInt(5))).then((_) {
            if (!mounted) return;
            animationController.reset();
            animationController.forward();
          });
        });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0) * 4;
    if (widget.horizontalShake) return Vector3(offset, 0.0, 0.0);
    return Vector3(0.0, offset, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_shake()),
      child: Icon(
        widget.icon,
        size: widget.size,
        color: widget.color != null ? widget.color : null,
      ),
    );
  }
}
