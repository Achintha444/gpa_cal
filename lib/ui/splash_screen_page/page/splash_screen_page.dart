import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              child: Image(
                image: AssetImage('graphics/logo.png'),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
