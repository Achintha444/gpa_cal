import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/ui/add_semester_page/page/add_semester_page.dart';
import 'package:gpa_cal/util/ui_util/custom_app_bar.dart';

import '../../db/model/user_details_model.dart';
import 'add_semester_bloc.dart';
import 'add_semester_state.dart';

class AddSemesterView extends StatelessWidget {
  static final log = Log("AddSemesterView");

  final UserDetailsModel userDetailsModel;
  final String semesterName;
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  const AddSemesterView({Key key, @required this.userDetailsModel, @required this.semesterName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddSemesterBloc, AddSemesterState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text(state.error),
                  action: SnackBarAction(
                    label: 'CLEAR',
                    onPressed: () {
                       _scaffoldKey.currentState.hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            name: userDetailsModel.name,
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AddSemesterPage(semesterName: semesterName),
          ),
        ),
      ),
    );
  }
}
