import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/db/model/subject.dart';
import 'package:gpa_cal/ui/edit_semester_page/widgets/edit_semester_subject_card.dart';

import '../../../db/model/semester.dart';
import '../../../db/model/user_details_model.dart';
import '../edit_semester_bloc.dart';
import '../edit_semester_event.dart';

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
  int _subjectCount;
  int _lengthOfWidgets;
  List<Widget> _widgetList;

  @override
  void initState() {
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
                    DeleteEditSubjectEvent(index, widget.userDetailsModel.gpaType),
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
            initSubject: Subject.fromJson(widget.semesterName.subjectList[index]) ,
          ),
        ],
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: _widgetList,),
    );
  }
}
