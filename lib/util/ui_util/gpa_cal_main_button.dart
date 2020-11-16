import 'package:flutter/material.dart';

import '../../theme/project_theme.dart';

class GpaCalMainButton extends StatelessWidget {
  const GpaCalMainButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () {},
        color: ProjectColours.BUTTON_BG_COLOR,
        textColor: ProjectColours.SCAFFOLD_BACKGROUND,
        child: Text(
          'Continue'.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.25,
          ),
        ),
      ),
    );
  }
}