import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpa_cal/util/ui_util/error_animated_widget.dart';

import '../../../theme/project_theme.dart';

class AddSemesterPage extends StatelessWidget {
  final String semesterName;

  const AddSemesterPage({Key key, @required this.semesterName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * (123 / 823),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: ProjectThemes.containerDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: 'Hero Tag 2',
                child: SvgPicture.asset(
                  'graphics/person.svg',
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * (96 / 411),
                  height: MediaQuery.of(context).size.height / 8.5,
                ),
              ),
              SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 4),
                  Text(
                    semesterName,
                    style: TextStyle(
                      color: ProjectColours.PRIMARY_COLOR,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  //ErrorAnimatedWidget(child: null, direction: null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'SGPA',
                        style: TextStyle(
                          color: ProjectColours.SET_NAME_COLOUR,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '4.0',
                        style: TextStyle(
                          color: ProjectColours.SET_NAME_COLOUR,
                          fontSize: 34,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
