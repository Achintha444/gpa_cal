import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/project_theme.dart';
import 'ui/splash_form_page/splash_form_exports.dart';
import 'ui/splash_screen_page/splash_screen_exports.dart';

class GpaCal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'graphics/background.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment
                .bottomRight, // 10% of the width, so there are ten blinds.
            colors: [
              const Color(0xffffffff),
              Colors.transparent
            ], // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
          /* boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(5, 5), // changes position of shadow
            ),
          ], */
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: MaterialApp(
            title: 'GPA CAL',
            theme: projectTheme,
            home: SplashScreenProvider(),
            debugShowCheckedModeBanner: false,
            routes: {
              '/splashFormPage': (context) => new SplashFormProvider(),
            },
          ),
        ),
      ),
    );
  }
}
