import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';
import 'package:gpa_cal/theme/project_theme.dart';
import 'package:gpa_cal/ui/add_semester_page/add_semester_exports.dart';
import 'package:gpa_cal/ui/home_page/home_exports.dart';
import 'package:gpa_cal/util/ui_util/error_animated_widget.dart';

class SetSemesterNameDialog extends StatefulWidget {
  final UserDetailsModel userDetailsModel;

  const SetSemesterNameDialog({
    Key key,
    @required this.userDetailsModel,
  }) : super(key: key);

  @override
  _SetSemesterNameDialogState createState() => _SetSemesterNameDialogState();
}

class _SetSemesterNameDialogState extends State<SetSemesterNameDialog> {
  String _semester_name;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 220,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Semester Name',
              style: TextStyle(
                color: ProjectColours.PRIMARY_COLOR,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            ErrorAnimatedWidget(
              child: _error == true
                  ? Text(
                      'Semester cannot be empty right ? 😉',
                      style: _erroTextStyle(),
                    )
                  : SizedBox(
                      height: 13,
                    ),
              direction: -1.1,
            ),
            SizedBox(height: 8),
            TextFormField(
              autofocus: true,
              decoration: _error == false
                  ? _inputDecoration('Name')
                  : _inputErrorDecoration('Name'),
              style: _inputTextStyle(),
              textCapitalization: TextCapitalization.sentences,
              maxLength: 25,
              maxLengthEnforced: true,
              maxLines: 1,
              textAlign: TextAlign.left,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty || value.trim().isEmpty) {
                    _error = true;
                  } else {
                    _error = false;
                    _semester_name = value;
                  }
                });
              },
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    textAlign: TextAlign.end,
                    style: _buttonTextStyle(
                      ProjectColours.PRIMARY_COLOR,
                      FontWeight.w500,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if (_error == false) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddSemesterProvider(
                              userDetailsModel: widget.userDetailsModel,
                              semesterName: _semester_name,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Text(
                    'SET NAME',
                    textAlign: TextAlign.end,
                    style: _buttonTextStyle(
                      ProjectColours.SET_NAME_COLOUR,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _inputTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.75,
    );
  }

  TextStyle _buttonTextStyle(Color color, FontWeight fontWeight) {
    return TextStyle(
      fontSize: 14,
      fontWeight: fontWeight,
      letterSpacing: 1.25,
      color: color,
    );
  }

  TextStyle _erroTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: ProjectColours.ERROR_COLOR,
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      hintText: labelText,
      contentPadding:
          const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0, right: 8),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      hintStyle: TextStyle(
        color: ProjectColours.PRIMARY_COLOR.withOpacity(0.75),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontSize: 16,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  InputDecoration _inputErrorDecoration(String labelText) {
    return InputDecoration(
      hintText: labelText,
      contentPadding:
          const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0, right: 8),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      hintStyle: TextStyle(
        color: ProjectColours.ERROR_COLOR.withOpacity(0.75),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontSize: 16,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }
}
