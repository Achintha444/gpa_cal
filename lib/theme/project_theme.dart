import 'package:flutter/material.dart';

var projectTheme = ThemeData(
  primaryColor: ProjectColours.PRIMARY_COLOR,
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
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(20),
    ),
  ),
  
);

abstract class ProjectColours {
  static const Color PRIMARY_COLOR = Color(0xff3A86FF);
  static const Color SCAFFOLD_BACKGROUND = Color(0xffEEF5FF);
  static const Color ERROR_COLOR = Color(0xffFF006E);
  static const Color BUTTON_BG_COLOR = Color(0xffFFBE0B);
}
