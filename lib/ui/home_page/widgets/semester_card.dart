import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../db/model/semester.dart';
import '../../../theme/project_theme.dart';
import '../../../util/ui_util/custom_alert_dialog.dart';
import '../home_bloc.dart';
import '../home_event.dart';

class SemesterCard extends StatelessWidget {
  final int index;
  final Semester semester;
  final HomeBloc homeBloc;

  const SemesterCard({
    Key key,
    @required this.index,
    @required this.semester,
    @required this.homeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (88 / 823),
      decoration: ProjectThemes.semesterContainerDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            decoration: BoxDecoration(
              color: ProjectColours.PRIMARY_COLOR,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SizedBox()),

                /// Semester Name
                Text(
                  semester.name,
                  style: TextStyle(
                    color: ProjectColours.PRIMARY_COLOR,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),

                /// SGPA
                Text(
                  'SGPA ' + semester.sgpa.toString(),
                  style: TextStyle(
                    color: ProjectColours.PRIMARY_COLOR,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),

          /// Semester Card Edit
          /* SizedBox(width: 16),
          SemesterCardIconButton(
            icon: Icon(Icons.edit),
            iconColor: ProjectColours.PRIMARY_COLOR,
            color: ProjectColours.BUTTON_BG_COLOR,
            borderRadius: null,
            onPressed: () {},
          ), */
          SizedBox(width: 16),
          SemesterCardIconButton(
            icon: Icon(Icons.delete),
            iconColor: ProjectColours.BUTTON_BG_COLOR,
            color: ProjectColours.PRIMARY_COLOR,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onConfirm: (){
                        homeBloc.add(DeleteSemesterEvent(semester));
                      },
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}

class SemesterCardIconButton extends StatelessWidget {
  final Icon icon;
  final Color iconColor;
  final Color color;
  final BorderRadius borderRadius;
  final Function onPressed;

  const SemesterCardIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    @required this.iconColor,
    @required this.color,
    @required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        border: Border.all(color: color, width: 5),
        borderRadius: borderRadius,
      ),
      child: IconButton(
        icon: icon,
        color: iconColor,
        onPressed: () => this.onPressed(),
      ),
    );
  }
}
