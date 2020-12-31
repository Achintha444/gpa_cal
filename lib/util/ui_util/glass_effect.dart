import 'dart:ui';

import 'package:flutter/material.dart';

class GlassEffect extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const GlassEffect({
    Key key,
    @required this.child,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(5, 5), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              //color: Colors.white.withOpacity(0.1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.clamp,
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0),
                ],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
