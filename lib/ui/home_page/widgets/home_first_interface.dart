import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../db/model/user_details_model.dart';
import '../../../theme/project_theme.dart';
import '../../../util/ui_util/gpa_cal_main_button.dart';
import 'set_semester_name_dialog.dart';

class HomeFirstInterface extends StatelessWidget {
  final UserDetailsModel userDetailsModel;

  const HomeFirstInterface({Key key, @required this.userDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Stack(
        children: [
          Positioned(
            top: 100 * MediaQuery.of(context).size.height / 843,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding:
                    EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
                height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(
                      'We know calculating your GPA is a tough task 😉.',
                      textAlign: TextAlign.center,
                      style: _subtitleTextStyle(FontWeight.w400),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Don’t worry we are here to help you!',
                      textAlign: TextAlign.center,
                      style: _subtitleTextStyle(FontWeight.w600),
                    ),
                    SizedBox(height: 32),
                    GpaCalMainButton(
                      text: 'Add Semester',
                      onClick: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SetSemesterNameDialog(
                              userDetailsModel: userDetailsModel,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'to Start 🤗',
                      textAlign: TextAlign.center,
                      style: _subtitleTextStyle(FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              'graphics/books.svg',
              height: 200 * MediaQuery.of(context).size.height / 823,
              allowDrawingOutsideViewBox: false,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _subtitleTextStyle(FontWeight fontWeight) {
    return TextStyle(
      color: ProjectColours.DARKER_COLOR,
      fontSize: 18,
      fontWeight: fontWeight,
      letterSpacing: 0.75,
    );
  }
}
