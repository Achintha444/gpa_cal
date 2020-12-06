import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/project_theme.dart';

class EditSemesterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  static final AppBar appBar = new AppBar();
  final String name;
  final Function onBack;
  final Function onDelete;

  const EditSemesterAppBar({Key key, @required this.name, @required this.onBack, @required this.onDelete})
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
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () => onBack(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete Semester',
              onPressed: () {},
            ),
          ],
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
      ],
    );
  }

  @override
  Size get preferredSize =>
      new Size.fromHeight(appBar.preferredSize.height + 8 + 14 + 19);
}
