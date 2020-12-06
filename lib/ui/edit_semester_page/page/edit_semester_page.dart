import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../db/model/semester.dart';
import '../../../db/model/subject.dart';
import '../../../db/model/user_details_model.dart';
import '../../../theme/project_theme.dart';
import '../../../util/ui_util/error_animated_widget.dart';
import '../../../util/ui_util/gpa_cal_main_button.dart';
import '../edit_semester_bloc.dart';
import '../edit_semester_event.dart';
import '../edit_semester_exports.dart';
import '../widgets/edit_name_bottom_sheet.dart';
import '../widgets/edit_semester_new_subject_card.dart';
import '../widgets/edit_semester_subject_card.dart';

class EditSemesterPage extends StatefulWidget {
  final Semester semesterName;
  final UserDetailsModel userDetailsModel;

  const EditSemesterPage({
    Key key,
    @required this.semesterName,
    @required this.userDetailsModel,
  }) : super(key: key);

  @override
  _EditSemesterPageState createState() => _EditSemesterPageState();
}

class _EditSemesterPageState extends State<EditSemesterPage> {
  String _name;
  int _subjectCount;
  int _lengthOfWidgets;
  List<Widget> _widgetList;

  @override
  void initState() {
    _name = widget.semesterName.name;
    _subjectCount = widget.semesterName.subjectList.length;
    _lengthOfWidgets = _subjectCount;

    _widgetList = new List.generate(
      _lengthOfWidgets,
      (index) => Column(
        children: [
          SizedBox(height: 8),
          EditSemesterSubjectCard(
            index: index,
            userDetailsModel: widget.userDetailsModel,
            onDelete: (int index) {
              setState(() {
                if (_subjectCount > 1) {
                  print(index.toString() + ' sRemoved from task list');
                  _subjectCount -= 1;
                  _widgetList[index] = SizedBox(width: 0, height: 0);
                  BlocProvider.of<EditSemesterBloc>(context).add(
                    DeleteEditSubjectEvent(
                      index,
                      widget.userDetailsModel.gpaType,
                    ),
                  );
                } else {
                  BlocProvider.of<EditSemesterBloc>(context).add(
                    ErrorEvent(
                      'Cannot delete since only one course left',
                    ),
                  );
                }
              });
            },
            initSubject: Subject.fromJson(
              widget.semesterName.subjectList[index],
            ),
          ),
        ],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final editSemesterBloc = BlocProvider.of<EditSemesterBloc>(context);

    return Container(
      child: BlocBuilder<EditSemesterBloc, EditSemesterState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit ' + _name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: ProjectColours.PRIMARY_COLOR,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(height: 4),
              Divider(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// SGPA
                  Text(
                    'SGPA',
                    style: TextStyle(
                      color: ProjectColours.PRIMARY_COLOR,
                      fontSize: 14,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    state.sgpa.toString(),
                    style: TextStyle(
                      color: ProjectColours.SET_NAME_COLOUR,
                      fontSize: 16,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Container(
                    height: 24,
                    child: VerticalDivider(
                      width: 32,
                    ),
                  ),

                  /// Name
                  Text(
                    'Name',
                    style: TextStyle(
                      color: ProjectColours.PRIMARY_COLOR,
                      fontSize: 14,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ProjectColours.SET_NAME_COLOUR,
                        fontSize: 16,
                        letterSpacing: 0.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: 'Edit Name',
                    color: ProjectColours.PRIMARY_COLOR,
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      showBottomSheet(context: context, builder: (context){
                        return EditNameBottomSheet(name: _name, onConfirm: (newName){
                          setState(() {
                            _name = newName;
                          });
                        });
                      });
                    },
                  ),
                ],
              ),
              Divider(height: 24),
              Text(
                'Courses - ' + _subjectCount.toString(),
                style: TextStyle(
                  color: ProjectColours.PRIMARY_COLOR,
                  fontSize: 14,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    //
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
                                          EditSmesterNewSubjectCard(
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
                                                    _widgetList[index] =
                                                        SizedBox(
                                                            height: 0,
                                                            width: 0);
                                                    editSemesterBloc.add(
                                                      DeleteEditSubjectEvent(
                                                          index,
                                                          widget
                                                              .userDetailsModel
                                                              .gpaType),
                                                    );
                                                  } else {
                                                    editSemesterBloc.add(
                                                      ErrorEvent(
                                                        'Cannot delete since only one course left',
                                                      ),
                                                    );
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
                child: GpaCalMainButton(
                  text: 'Confirm',
                  onClick: () {
                    if (state.totalError) {
                      editSemesterBloc
                          .add(ErrorEvent('Course fields are not complete!'));
                    } else {
                      editSemesterBloc.add(EditConfirmEvent(_name));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
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
