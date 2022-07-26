import 'package:flutter/material.dart';

class CircleAnimation extends StatefulWidget {
  final Widget child;
  const CircleAnimation({Key? key, required this.child}) : super(key: key);

  @override
  State<CircleAnimation> createState() => _CircleAnimationState();
}

class _CircleAnimationState extends State<CircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );
    _animationController.forward();
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
