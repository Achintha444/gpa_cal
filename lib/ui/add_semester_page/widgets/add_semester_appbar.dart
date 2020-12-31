import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gpa_cal/util/ui_util/glass_effect.dart';

import '../../../theme/project_theme.dart';

class AddSemesterAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final AppBar appBar = new AppBar();
  final String name;
  final String university;
  final Function onBack;
  final double borderRadius = 60;

  const AddSemesterAppBar({
    Key key,
    @required this.name,
    @required this.university,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
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
          borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(borderRadius)),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(borderRadius)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Stack(
              children: [
                //* SVG
                Positioned(
                  right: -72,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.6,
                    child: SvgPicture.asset(
                      'graphics/person.svg',
                      alignment: Alignment.centerLeft,
                      height: 200 * MediaQuery.of(context).size.height / 823,
                      colorBlendMode: BlendMode.luminosity,
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  bottom: 0,
                  child: GlassEffect(
                    topColorOpacity: 0.6,
                    bottomColorOpacity: 0.2,
                    borderWidth: 1,
                    borderOpacity: 0.1,
                    height: 88 * MediaQuery.of(context).size.height / 843,
                    width: 277 * MediaQuery.of(context).size.width / 411,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 56),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CGPA',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: ProjectColours.PRIMARY_COLOR),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '4.00/4.20',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                color: ProjectColours.PRIMARY_COLOR),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //* User Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(borderRadius),
                        ),
                      ),
                      title: Padding(
                        padding: onBack == null
                            ? const EdgeInsets.only(left: 40.0)
                            : const EdgeInsets.only(left: 0.0),
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
                      padding:
                          const EdgeInsets.only(left: 56, top: 0, right: 8),
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
                        padding:
                            const EdgeInsets.only(left: 56, top: 4, right: 8),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      new Size.fromHeight(appBar.preferredSize.height + 130);
}
