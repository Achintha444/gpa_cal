import 'package:flutter/material.dart';

class ErrorAnimatedWidget extends StatelessWidget {
  final Widget child;
  /// direction = 1 -> upward animation
  /// direction = -1 -> downward animation
  final double direction;
  const ErrorAnimatedWidget({
    Key key,
    @required this.child,
    @required this.direction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
      ) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, direction),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
      child: child
    );
  }
}