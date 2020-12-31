import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../util/ui_util/glass_effect.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Hero(
          tag: 'HeroLogo',
          child: GlassEffect(
            height: 216,
            width: 216,
            child: Image(
              image: AssetImage('graphics/logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}