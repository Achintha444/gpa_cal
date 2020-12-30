import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../util/ui_util/loading_screen.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'HeroLogo',
            child: Container(
              height: 216,
              decoration: BoxDecoration(
                  // color: Colors.transparent,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment
                        .bottomRight, // 10% of the width, so there are ten blinds.
                    colors: [
                      const Color(0xffffffff),
                      Colors.transparent
                    ], // red to yellow
                    tileMode: TileMode
                        .repeated, // repeats the gradient over the canvas
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(5, 5), // changes position of shadow
                    ),
                  ],
                  border: Border.all(color: Colors.red,width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Image(
                  image: AssetImage('graphics/logo.png'),
                ),
              ),
            ),
          ),
          SizedBox(height: 100),
          Hero(
            tag: 'Hero Tag 2',
            child: Container(
              height: 216,
              child: SvgPicture.asset(
                'graphics/cap.svg',
                placeholderBuilder: (context) {
                  return Container(
                    height: 216,
                    child: LoadingScreen(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
