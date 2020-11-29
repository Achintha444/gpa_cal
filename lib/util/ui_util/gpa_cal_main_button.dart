import 'package:flutter/material.dart';

import '../../theme/project_theme.dart';

class GpaCalMainButton extends StatelessWidget {
  final String text;
  final Function onClick;

  const GpaCalMainButton({
    Key key,
    @required this.text,
    @required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => this.onClick(),
        color: ProjectColours.PRIMARY_COLOR,
        textColor: ProjectColours.BUTTON_BG_COLOR,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
