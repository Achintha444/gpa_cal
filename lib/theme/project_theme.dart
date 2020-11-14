import 'package:flutter/material.dart';

var projectTheme = ThemeData(
  scaffoldBackgroundColor: ProjectColours.SCAFFOLD_BACKGROUND,
  errorColor: ProjectColours.ERROR_COLOR,
  fontFamily: 'Montserrat',
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(
      letterSpacing: 0.4,
      color: ProjectColours.SCAFFOLD_BACKGROUND,
    ),
    actionTextColor: ProjectColours.SCAFFOLD_BACKGROUND,
  ),
);

abstract class ProjectColours {
  static const Color SCAFFOLD_BACKGROUND = Color(0xffEEF5FF);
  static const Color ERROR_COLOR = Color(0xffFF006E);
}
