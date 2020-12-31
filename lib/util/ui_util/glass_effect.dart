import 'dart:ui';

import 'package:flutter/material.dart';

class GlassEffect extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  /// first color opacity
  final double topColorOpacity;

  /// bottom color opacity
  final double bottomColorOpacity;

  final double borderOpacity;
  final double borderWidth;

  final BorderRadiusGeometry borderRadius;

  const GlassEffect({
    Key key,
    @required this.child,
    @required this.height,
    @required this.width,
    this.topColorOpacity = 0.3,
    this.bottomColorOpacity = 0,
    this.borderOpacity = 0.3,
    this.borderWidth = 2,
    this.borderRadius,
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
        borderRadius: borderRadius == null
            ? BorderRadius.all(
                Radius.circular(20),
              )
            : borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius == null
            ? BorderRadius.all(
                Radius.circular(20),
              )
            : borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
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
                  Colors.white.withOpacity(topColorOpacity),
                  Colors.white.withOpacity(bottomColorOpacity),
                ],
              ),
              borderRadius: borderRadius == null
                  ? BorderRadius.all(
                      Radius.circular(20),
                    )
                  : borderRadius,
              border: Border.all(
                color: Colors.white.withOpacity(borderOpacity),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
