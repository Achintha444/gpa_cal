import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/project_theme.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: new Duration(seconds: 2),
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
    );
    animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        height: (MediaQuery.of(context).size.height) / 2,
        child: Center(
          child: CircularProgressIndicator(
            key: Key('circularProgressIndicator'),
            strokeWidth: 5,
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
            valueColor: animationController.drive(
              ColorTween(
                begin: ProjectColours.PRIMARY_COLOR,
                end: ProjectColours.ERROR_COLOR,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
