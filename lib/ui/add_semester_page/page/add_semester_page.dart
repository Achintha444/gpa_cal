import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';
import 'package:gpa_cal/ui/add_semester_page/add_semester_bloc.dart';
import 'package:gpa_cal/ui/add_semester_page/add_semester_event.dart';
import 'package:gpa_cal/ui/add_semester_page/add_semester_exports.dart';
import 'package:gpa_cal/util/ui_util/error_animated_widget.dart';

import '../../../theme/project_theme.dart';
import '../../../util/ui_util/gpa_cal_main_button.dart';
import '../widgets/subject_card.dart';

class AddSemesterPage extends StatefulWidget {
  final String semesterName;
  final UserDetailsModel userDetailsModel;

  const AddSemesterPage(
      {Key key, @required this.semesterName, @required this.userDetailsModel})
      : super(key: key);

  @override
  _AddSemesterPageState createState() => _AddSemesterPageState();
}

class _AddSemesterPageState extends State<AddSemesterPage> {
  int _subjectCount;
  int _lengthOfWidgets;
  List<Widget> _widgetList;

  @override
  void initState() {
    _subjectCount = 1;
    _lengthOfWidgets = 1;
    _widgetList = new List.generate(
      1,
      (index) => Column(
        children: [
          SizedBox(height: 8),
          SubjectCard(
            index: index,
            userDetailsModel: widget.userDetailsModel,
            onDelete: (int index) {
              setState(() {
                if (_subjectCount > 1) {
                  print(index.toString() + ' sRemoved from task list');
                  _subjectCount -= 1;
                  _widgetList[index] = SizedBox(width: 0, height: 0);
                  BlocProvider.of<AddSemesterBloc>(context).add(
                      DeleteSubjectEvent(
                          index, widget.userDetailsModel.gpaType));
                } else {
                  BlocProvider.of<AddSemesterBloc>(context).add(ErrorEvent(
                    'Cannot delete since only one course left',
                  ));
                }
              });
            },
          ),
        ],
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final addSemesterBloc = BlocProvider.of<AddSemesterBloc>(context);

    return BlocBuilder<AddSemesterBloc, AddSemesterState>(
      builder: (context, state) {
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
                            width:
                                MediaQuery.of(context).size.width * (96 / 411),
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
                              widget.semesterName,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              textWidthBasis: TextWidthBasis.parent,
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
                    'Courses - '+_subjectCount.toString(),
                    style: TextStyle(
                      color: ProjectColours.PRIMARY_COLOR,
                      fontSize: 14,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // SizedBox(height: 2),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: ErrorAnimatedWidget(
                      child: state.emptySubjects.isEmpty
                          ? SizedBox(
                              height: 13,
                            )
                          : Text(
                              'Course Fields Cannot be Empty!',
                              style: _erroTextStyle(),
                            ),
                      direction: -1,
                    ),
                  ),

                  //SubjectCard(),
                  Column(
                    children: _widgetList,
                  ),

                  SizedBox(height: 16),

                  Align(
                    alignment: Alignment.topRight,
                    child: FlatButton(
                      onPressed: state.totalError == true
                          ? null
                          : () {
                              print(state.totalError);
                              setState(
                                () {
                                  _lengthOfWidgets += 1;
                                  _subjectCount += 1;
                                  _widgetList.add(
                                    Column(
                                      children: [
                                        SizedBox(height: 8),
                                        SubjectCard(
                                          userDetailsModel:
                                              widget.userDetailsModel,
                                          index: _lengthOfWidgets - 1,
                                          onDelete: (int index) {
                                            //_widgetList.

                                            setState(
                                              () {
                                                if (_subjectCount > 1) {
                                                  print(index.toString() +
                                                      ' sRemoved from task list');
                                                  _subjectCount -= 1;
                                                  _widgetList[index] = SizedBox(
                                                      height: 0, width: 0);
                                                  addSemesterBloc.add(
                                                    DeleteSubjectEvent(index, widget.userDetailsModel.gpaType),
                                                  );
                                                } else {
                                                  addSemesterBloc
                                                      .add(ErrorEvent(
                                                    'Cannot delete since only one course left',
                                                  ));
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: ProjectColours.SET_NAME_COLOUR,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      disabledTextColor:
                          ProjectColours.SET_NAME_COLOUR.withOpacity(0.2),
                      textColor: ProjectColours.SET_NAME_COLOUR,
                      child: Text(
                        '+ Add New Course',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
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
      },
    );
  }

  TextStyle _erroTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: ProjectColours.ERROR_COLOR,
    );
  }
}
