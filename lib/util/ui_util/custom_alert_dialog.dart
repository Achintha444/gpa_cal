import 'package:flutter/material.dart';

import '../../theme/project_theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final Function onCancel;
  final Function onConfirm;

  const CustomAlertDialog({
    Key key,
    @required this.onCancel,
    @required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Container(
        height: 223,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              color: ProjectColours.ERROR_COLOR,
              size: 40,
            ),
            SizedBox(height: 4),
            Text(
              'IMPORTANT!',
              style: TextStyle(
                  color: ProjectColours.ERROR_COLOR,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'All the current details of this semester will be deleted!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 4),
            Text(
              'Do you want to continue?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () => this.onCancel(),
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
                  onPressed: () => this.onConfirm(),
                  child: Text(
                    'OK',
                    textAlign: TextAlign.end,
                    style: _buttonTextStyle(
                      ProjectColours.ERROR_COLOR,
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
}
