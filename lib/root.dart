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
    return MaterialApp(
      title: 'GPA CAL',
      theme: projectTheme,
      home: SplashScreenProvider(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/splashFormPage' : (context) => new SplashFormProvider(),
      },
    );
  }
}