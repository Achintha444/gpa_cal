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
            'graphics/image.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 100,
              offset: Offset(80, 100), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.clamp,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
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
        ),
      ),
    );
  }
}
