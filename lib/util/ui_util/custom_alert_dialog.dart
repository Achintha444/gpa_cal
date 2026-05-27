import 'package:flutter/material.dart';

import '../../theme/project_theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CustomAlertDialog({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Container(
        height: 223,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              color: ProjectColours.ERROR_COLOR,
              size: 40,
            ),
            const SizedBox(height: 4),
            Text(
              'IMPORTANT!',
              style: TextStyle(
                  color: ProjectColours.ERROR_COLOR,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'All the current details of this semester will be deleted!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 4),
            const Text(
              'Do you want to continue?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: Text(
                    'CANCEL',
                    textAlign: TextAlign.end,
                    style: _buttonTextStyle(
                      ProjectColours.PRIMARY_COLOR,
                      FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onConfirm,
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


  TextStyle _buttonTextStyle(Color color, FontWeight fontWeight) {
    return TextStyle(
      fontSize: 14,
      fontWeight: fontWeight,
      letterSpacing: 1.25,
      color: color,
    );
  }
}
