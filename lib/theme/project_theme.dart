import 'package:flutter/material.dart';

var projectTheme = ThemeData(
  primaryColor: ProjectColours.PRIMARY_COLOR,
  unselectedWidgetColor: ProjectColours.PRIMARY_COLOR,
  scaffoldBackgroundColor: ProjectColours.SCAFFOLD_BACKGROUND,
  errorColor: ProjectColours.ERROR_COLOR,
  fontFamily: 'Montserrat',
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(
      letterSpacing: 0.4,
      color: ProjectColours.SCAFFOLD_BACKGROUND,
    ),
    backgroundColor: ProjectColours.SNACKBAR_BG_COLOR,
    actionTextColor: ProjectColours.SCAFFOLD_BACKGROUND,
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(20),
    ),
  ),
  appBarTheme: AppBarTheme(
    color: ProjectColours.SCAFFOLD_BACKGROUND,
    actionsIconTheme: IconThemeData(
      color: ProjectColours.PRIMARY_COLOR,
      size: 24,
    ),
    iconTheme: IconThemeData(
      color: ProjectColours.PRIMARY_COLOR,
      size: 24,
    ),
    elevation: 0,
    textTheme: TextTheme(
      headline6: TextStyle(
          fontSize: 20,
          fontFamily: 'Montserrat',
          color: ProjectColours.PRIMARY_COLOR,
          letterSpacing: 0.15),
    ),
  ),
  tooltipTheme: TooltipThemeData(
    textStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.4,
      color: ProjectColours.SCAFFOLD_BACKGROUND,
    ),
    decoration: BoxDecoration(
      color: ProjectColours.SNACKBAR_BG_COLOR.withOpacity(0.9),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    height: 32,
    padding: EdgeInsets.only(left: 16, right: 16),
  ),
);

abstract class ProjectColours {
  static const Color PRIMARY_COLOR = Color(0xff3A86FF);
  static const Color SCAFFOLD_BACKGROUND = Color(0xffEEF5FF);
  static const Color ERROR_COLOR = Color(0xffFF006E);
  static const Color BUTTON_BG_COLOR = Color(0xffFFBE0B);
  static const Color SNACKBAR_BG_COLOR = Color(0xff8338EC);
}
