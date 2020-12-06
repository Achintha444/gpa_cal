import 'package:flutter/material.dart';

import '../../../db/model/semester.dart';
import '../../../db/model/user_details_model.dart';
import '../../../theme/project_theme.dart';
import '../../../util/ui_util/custom_alert_dialog.dart';
import '../../edit_semester_page/edit_semester_exports.dart';
import '../home_bloc.dart';
import '../home_event.dart';

class SemesterCard extends StatelessWidget {
  final int index;
  final UserDetailsModel userDetailsModel;
  final Semester semester;
  final HomeBloc homeBloc;

  const SemesterCard({
    Key key,
    @required this.index,
    @required this.userDetailsModel,
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
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditSemesterProvider(
                      userDetailsModel: userDetailsModel,
                      semester: semester,
                    );
                  }));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 16),
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
              ),
            ),
          ),
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
                      onConfirm: () {
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
        tooltip: 'Delete Semester',
      ),
    );
  }
}
