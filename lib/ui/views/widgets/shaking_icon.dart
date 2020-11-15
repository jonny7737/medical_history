import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ShakingIcon extends StatefulWidget {
  /// Icon to shake - This can be either an IconData object
  /// or a String assetName for an AssetImage.
  final dynamic icon;

  /// Size parameter passed to Icon constructor
  final double size;

  /// Color parameter passed to Icon constructor
  final Color color;

  /// Enable / Disable shake to support dynamic UI
  /// Default to true
  final bool shake;

  /// Horizontal shake.  Default to Horizontal shake
  final bool horizontalShake;

  /// Vertical shake.  Default to Horizontal shake
  final bool verticalShake;

  /// Frequency to repeat the shake in seconds
  final int secondsToRepeat;

  /// [ShakingTitleIcon(this.icon, {@required this.size, this.color, this.horizontalShake})]
  ///
  ///     1. [icon]: IconData (Icons.) for icon to shake.
  ///
  ///     2. [horizontalShake]: Shake horizontally if true.
  ///
  ///     3. [verticalShake]: Shake vertically if true.
  ///
  ///     Diagonal shack if horizontal and vertical are both true.
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
    this.verticalShake = false,
    this.secondsToRepeat = 0,
  });

  @override
  _ShakingIconState createState() => _ShakingIconState();
}

class _ShakingIconState extends State<ShakingIcon> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Timer timer;
  final Random rng = Random();
  dynamic child;

  @override
  Widget build(BuildContext context) {
    if (widget.icon.runtimeType == IconData)
      child = Icon(
        widget.icon,
        size: widget.size,
        color: widget.color,
      );
    else if (widget.icon.runtimeType == String) {
      child = ImageIcon(
        AssetImage(widget.icon),
        size: widget.size,
        color: widget.color,
      );
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (_, child) {
        return Transform(
          transform: Matrix4.translation(_shake()),
          child: child,
        );
      },
      child: child,
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
          waitForIt();
        });
    }
  }

  void waitForIt() {
    /// Random delay between 0.5 and 5 seconds.
    Future.delayed(Duration(milliseconds: nextRndInt(min: 1, max: 10) * 500)).then((_) {
      if (!mounted) return;
      if (ExpandableController.of(context).expanded) return;
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
    double xOffset = widget.horizontalShake ? offset : 0.0;
    double yOffset = widget.verticalShake ? offset : 0.0;
    return Vector3(xOffset, yOffset, 0.0);
  }
}
