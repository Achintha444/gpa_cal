import 'package:flutter/material.dart';

import '../../../db/model/user_details_model.dart';
import '../../../theme/project_theme.dart';
import '../../../util/ui_util/error_animated_widget.dart';
import '../../add_semester_page/add_semester_exports.dart';

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
  String _semesterName = '';
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Container(
        height: 215,
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
              maxLength: 13,
              maxLengthEnforced: true,
              maxLines: 1,
              textAlign: TextAlign.left,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty ||
                      value.trim().isEmpty ||
                      value.length > 13) {
                    _error = true;
                  } else {
                    _error = false;
                    _semesterName = value;
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
                    if (_semesterName.isEmpty) {
                      setState(() {
                        _error = true;
                      });
                    } else {
                      if (_error == false) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddSemesterProvider(
                                userDetailsModel: widget.userDetailsModel,
                                semesterName: _semesterName,
                              );
                            },
                          ),
                        );
                      }
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
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
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
