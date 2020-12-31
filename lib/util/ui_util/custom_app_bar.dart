import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/project_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final AppBar appBar = new AppBar();
  final String name;
  final String university;
  final Function onBack;

  const CustomAppBar({
    Key key,
    @required this.name,
    @required this.university,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(5, 5))
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
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
                        onPressed: () => onBack(),
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
                padding: const EdgeInsets.only(left: 56, top: 0,right:8),
                child: Text(
                  'Welcome ' + name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ProjectColours.PRIMARY_COLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 56, top: 8,right:8),
                  child: Text(
                    'From ' + university,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ProjectColours.PRIMARY_COLOR,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      new Size.fromHeight(appBar.preferredSize.height + 8 + 14 + 12 + 8 + 16);
}
