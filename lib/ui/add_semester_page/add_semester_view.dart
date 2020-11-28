import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_semester_bloc.dart';
import 'add_semester_state.dart';

class AddSemesterView extends StatelessWidget {
  static final log = Log("AddSemesterView");

  @override
  Widget build(BuildContext context) {
    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      body: BlocBuilder<AddSemesterBloc, AddSemesterState>(
          buildWhen: (pre, current) => true,
          builder: (context, state) {
            return Center(
              child: Text("HI..."),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<AddSemesterBloc, AddSemesterState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              customSnackBar?.showErrorSnackBar(state.error);
            } else {
              customSnackBar?.hideAll();
            }
          },
        ),
      ],
      child: scaffold,
    );
  }
}
