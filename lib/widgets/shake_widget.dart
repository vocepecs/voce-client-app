import 'package:flutter/material.dart';
import 'package:voce/animations/animation_controller_state.dart';
import 'package:voce/animations/sine_curve_animation.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  @override
  State<ShakeWidget> createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration animationDuration) : super(animationDuration);

  @override
  void initState() {
    super.initState();
    // 1. register a status listener
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    // 2. dispose it when done
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    // 3. reset animationController when the animation is complete
    if (status == AnimationStatus.completed) {
      animationController.repeat();
    }
  }

  // 1. create a Tween
  late Animation<double> _sineAnimation = Tween(
    begin: 0.0,
    end: 1.0,
    // 2. animate it with a CurvedAnimation
  ).animate(CurvedAnimation(
    parent: animationController,
    // 3. use our SineCurve
    curve: SineCurve(count: widget.shakeCount.toDouble()),
  ));

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: _sineAnimation,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(_sineAnimation.value * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }

  void shake() {
    animationController.forward();
  }

  void stop() {
    animationController.stop();
  }
}
