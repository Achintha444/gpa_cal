import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_semester_bloc.dart';
import 'edit_semester_view.dart';

class EditSemesterProvider extends BlocProvider<EditSemesterBloc> {
  EditSemesterProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => EditSemesterBloc(context),
          child: EditSemesterView(),
        );
}
