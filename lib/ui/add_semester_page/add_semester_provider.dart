import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_semester_bloc.dart';
import 'add_semester_view.dart';

class AddSemesterProvider extends BlocProvider<AddSemesterBloc> {
  AddSemesterProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => AddSemesterBloc(context),
          child: AddSemesterView(),
        );
}
