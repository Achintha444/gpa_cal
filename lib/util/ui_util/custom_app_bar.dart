import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/project_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final AppBar appBar = new AppBar();
  final String name;
  final Function onBack;

  const CustomAppBar({Key key, @required this.name, this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  'GPA ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text('CAL'),
              ],
            ),
          ),
          leading: onBack == null
              ? null
              : IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: () => Navigator.of(context).pop(),
                ),
/*           actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              tooltip: 'More Options',
              onPressed: () {},
            ),
          ], */
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            'Welcome ' + name,
            style: TextStyle(
              color: ProjectColours.PRIMARY_COLOR,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Size get preferredSize =>
      new Size.fromHeight(appBar.preferredSize.height + 8 + 14 + 19);
}
