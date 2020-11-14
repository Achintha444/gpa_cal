import 'package:flutter/material.dart';

import 'theme/project_theme.dart';
import 'ui/splash_screen_page/splash_screen_exports.dart';

class GpaCal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA CAL',
      theme: projectTheme,
      home: SplashScreenProvider(),
    );
  }
}