import 'package:flutter/material.dart';

class ShakeAnimation extends StatefulWidget {
  const ShakeAnimation({super.key, this.child});
  final Widget? child;
  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  double _right = 0.0;
  double _left = 1.0;
  bool increaseLeft = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 1))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _left > 0) {
          if (!increaseLeft) {
            _right++;
            if (_right == 10) {
              increaseLeft = true;
              _right = 0;
            }
          }

          if (increaseLeft) {
            _left++;
            if (_left == 10) {
              // increaseLift = false;
              _left = 0;
            }
          }
          _animationController!.reset();
          _animationController!.forward();
        }
      });
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.only(right: _right, left: _left),
            child: widget.child,
          );
        });
  }
}
