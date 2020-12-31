import 'package:flutter/material.dart';

final projectTheme = ThemeData(
  primaryColor: ProjectColours.PRIMARY_COLOR,
  unselectedWidgetColor: ProjectColours.PRIMARY_COLOR,
  scaffoldBackgroundColor: Colors.transparent,

  errorColor: ProjectColours.ERROR_COLOR,
  fontFamily: 'Montserrat',
  dividerTheme: DividerThemeData(
    color: ProjectColours.PRIMARY_COLOR.withOpacity(0.15),
    thickness: 2,
  ),
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
      splashColor: ProjectColours.PRIMARY_COLOR.withOpacity(0.01)),
  appBarTheme: AppBarTheme(
    color: Colors.transparent.withOpacity(0),
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
        letterSpacing: 0.15,
      ),
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
  //splashColor: Colors.blue,
);

abstract class ProjectColours {
  static const Color PRIMARY_COLOR = Color(0xff3A86FF);
  static const Color SCAFFOLD_BACKGROUND = Color(0xffEEF5FF);
  static const Color ERROR_COLOR = Color(0xffFF006E);
  static const Color BUTTON_BG_COLOR = Color(0xffFFBE0B);
  static const Color SNACKBAR_BG_COLOR = Color(0xff8338EC);
  static const Color HOME_PAGE_EMPTY_CARD_COLOR = Color(0xffF9FBFF);
  static const Color HOME_PAGE_EMPTY_CARD_SHADOW_COLOR = Color(0xff3A86FF);
  static const Color SET_NAME_COLOUR = Color(0xffFB5607);
}

abstract class ProjectThemes {
  static BoxDecoration containerDecoration() {
    return BoxDecoration(
      color: ProjectColours.HOME_PAGE_EMPTY_CARD_COLOR,
      boxShadow: [
        BoxShadow(
          color: ProjectColours.HOME_PAGE_EMPTY_CARD_SHADOW_COLOR
              .withOpacity(0.25),
          spreadRadius: 0,
          blurRadius: 4,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ],
      shape: BoxShape.rectangle,
      border: Border.all(color: ProjectColours.PRIMARY_COLOR, width: 5),
      borderRadius: BorderRadius.circular(20),
    );
  }

  static BoxDecoration semesterContainerDecoration() {
    return BoxDecoration(
      color: ProjectColours.HOME_PAGE_EMPTY_CARD_COLOR,
      boxShadow: [
        BoxShadow(
          color: ProjectColours.HOME_PAGE_EMPTY_CARD_SHADOW_COLOR
              .withOpacity(0.25),
          spreadRadius: 0,
          blurRadius: 10,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ],
      shape: BoxShape.rectangle,
      //border: Border.all(color: ProjectColours.PRIMARY_COLOR, width: 5),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
