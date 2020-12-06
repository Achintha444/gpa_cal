import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../db/model/semester.dart';
import '../../db/model/user_details_model.dart';
import 'edit_semester_bloc.dart';
import 'edit_semester_view.dart';

class EditSemesterProvider extends BlocProvider<EditSemesterBloc> {
  final UserDetailsModel userDetailsModel;
  final Semester semester;

  EditSemesterProvider({
    Key key,
    @required this.userDetailsModel,
    @required this.semester,
  }) : super(
          key: key,
          create: (context) => EditSemesterBloc(context,semester),
          child: EditSemesterView(
            semester: semester,
            userDetailsModel: userDetailsModel,
          ),
        );
}
