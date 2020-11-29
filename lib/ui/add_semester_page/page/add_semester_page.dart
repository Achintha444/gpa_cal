import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/project_theme.dart';

class AddSemesterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * (123 / 823),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8),
          decoration: ProjectThemes.containerDecoration(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'Hero Tag 2',
                child: SvgPicture.asset(
                  'graphics/person.svg',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
