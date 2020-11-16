import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/project_theme.dart';

class SplashFormTitleText extends StatelessWidget {

  final String title;

  const SplashFormTitleText({
    Key key,
    @required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: TextStyle(
        color: ProjectColours.PRIMARY_COLOR,
        fontWeight: FontWeight.w200,
        fontSize: 16,
        letterSpacing: 0.4,
      ),
    );
  }
}