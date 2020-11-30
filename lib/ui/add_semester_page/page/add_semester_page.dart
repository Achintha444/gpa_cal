import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpa_cal/util/ui_util/gpa_cal_main_button.dart';

import '../../../theme/project_theme.dart';

class AddSemesterPage extends StatelessWidget {
  final String semesterName;

  const AddSemesterPage({Key key, @required this.semesterName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: MediaQuery.of(context).size.height * (123 / 823),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: ProjectThemes.containerDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'Hero Tag 2',
                      child: SvgPicture.asset(
                        'graphics/person.svg',
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * (96 / 411),
                        height: MediaQuery.of(context).size.height / 8.5,
                      ),
                    ),
                    SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          semesterName,
                          style: TextStyle(
                            color: ProjectColours.PRIMARY_COLOR,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        //ErrorAnimatedWidget(child: null, direction: null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'SGPA',
                              style: TextStyle(
                                color: ProjectColours.SET_NAME_COLOUR,
                                fontSize: 16,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '4.0',
                              style: TextStyle(
                                color: ProjectColours.SET_NAME_COLOUR,
                                fontSize: 34,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Courses',
                style: TextStyle(
                  color: ProjectColours.PRIMARY_COLOR,
                  fontSize: 14,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: ProjectColours.HOME_PAGE_EMPTY_CARD_COLOR,
                  boxShadow: [
                    BoxShadow(
                      color: ProjectColours.HOME_PAGE_EMPTY_CARD_SHADOW_COLOR
                          .withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: SizedBox()),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Subject',
                              contentPadding: const EdgeInsets.only(
                                left: 16.0,
                                bottom: 8.0,
                                top: 8.0,
                                right: 8,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ProjectColours.PRIMARY_COLOR,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ProjectColours.PRIMARY_COLOR,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelStyle: TextStyle(
                                color: ProjectColours.PRIMARY_COLOR
                                    .withOpacity(0.75),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15,
                                fontSize: 16,
                              ),
                              //floatingLabelBehavior: FloatingLabelBehavior.never,
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ProjectColours.ERROR_COLOR,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ProjectColours.ERROR_COLOR,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Subject',
                                    contentPadding: const EdgeInsets.only(
                                      left: 16.0,
                                      bottom: 8.0,
                                      top: 8.0,
                                      right: 8,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.PRIMARY_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.PRIMARY_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelStyle: TextStyle(
                                      color: ProjectColours.PRIMARY_COLOR
                                          .withOpacity(0.75),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.15,
                                      fontSize: 16,
                                    ),
                                    //floatingLabelBehavior: FloatingLabelBehavior.never,
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.ERROR_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.ERROR_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Subject',
                                    contentPadding: const EdgeInsets.only(
                                      left: 16.0,
                                      bottom: 8.0,
                                      top: 8.0,
                                      right: 8,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.PRIMARY_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.PRIMARY_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelStyle: TextStyle(
                                      color: ProjectColours.PRIMARY_COLOR
                                          .withOpacity(0.75),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.15,
                                      fontSize: 16,
                                    ),
                                    //floatingLabelBehavior: FloatingLabelBehavior.never,
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.ERROR_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ProjectColours.ERROR_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                    SizedBox(width: 24),
                    Container(
                      width: 48,
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                        color: ProjectColours.PRIMARY_COLOR,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            color: ProjectColours.PRIMARY_COLOR, width: 5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        color: ProjectColours.BUTTON_BG_COLOR,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.topRight,
                child: FlatButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: ProjectColours.SET_NAME_COLOUR,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Text(
                    '+ Add New Course',
                    style: TextStyle(
                      color: ProjectColours.SET_NAME_COLOUR,
                      fontWeight: FontWeight.w700,
                      fontSize: 11
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Confirm Button that will open a Confirm dialog
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: GpaCalMainButton(text: 'Confirm', onClick: () {}),
        ),
      ],
    );
  }
}
