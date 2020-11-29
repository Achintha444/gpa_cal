import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';

import 'add_semester_bloc.dart';
import 'add_semester_view.dart';

class AddSemesterProvider extends BlocProvider<AddSemesterBloc> {
  final UserDetailsModel userDetailsModel;
  final String semesterName;

  AddSemesterProvider({Key key, @required this.userDetailsModel, @required this.semesterName})
      : super(
          key: key,
          create: (context) => AddSemesterBloc(context),
          child: AddSemesterView(
            userDetailsModel: userDetailsModel,
            semesterName: semesterName,
          ),
        );
}
