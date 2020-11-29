import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gpa_cal/ui/home_page/page/set_semester_name_dialog.dart';
import 'package:gpa_cal/util/ui_util/gpa_cal_main_button.dart';

import '../../../db/model/user_details_model.dart';
import '../../../theme/project_theme.dart';

class HomeFirstInterface extends StatelessWidget {
  final UserDetailsModel userDetailsModel;

  const HomeFirstInterface({Key key, @required this.userDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 40),
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From ' + userDetailsModel.uni,
              style: _subtitleTextStyle(FontWeight.w400),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  color: ProjectColours.HOME_PAGE_EMPTY_CARD_COLOR,
                  boxShadow: [
                    BoxShadow(
                      color: ProjectColours.HOME_PAGE_EMPTY_CARD_SHADOW_COLOR
                          .withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(color: ProjectColours.PRIMARY_COLOR, width: 5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'Hero Tag 2',
                      child: SvgPicture.asset(
                        'graphics/person.svg',
                      ),
                    ),
                    SizedBox(height: 64),
                    Text(
                      'We know calculating your GPA is a tough task 😉.',
                      textAlign: TextAlign.center,
                      style: _subtitleTextStyle(FontWeight.w400),
                    ),
                    SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    Text(
                      'to Start 🤗',
                      textAlign: TextAlign.center,
                      style: _subtitleTextStyle(FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _subtitleTextStyle(FontWeight fontWeight) {
    return TextStyle(
      color: ProjectColours.PRIMARY_COLOR,
      fontSize: 16,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
    );
  }
}
