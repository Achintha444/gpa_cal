import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/util/ui_util/loading_screen.dart';

import '../../db/model/semester.dart';
import '../../db/model/user_details_model.dart';
import '../home_page/home_exports.dart';
import 'edit_semester_bloc.dart';
import 'edit_semester_state.dart';
import 'page/edit_semester_page.dart';
import 'widgets/edit_semester_app_bar.dart';
import 'widgets/edit_semester_custom_alert_dialog.dart';

// ignore: must_be_immutable
class EditSemesterView extends StatelessWidget {
  static final log = Log("EditSemesterView");

  final UserDetailsModel userDetailsModel;
  final Semester semester;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  EditSemesterView({
    Key key,
    @required this.userDetailsModel,
    @required this.semester,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log.d("Loading EditSemester View");

    return MultiBlocListener(
      listeners: [
        BlocListener<EditSemesterBloc, EditSemesterState>(
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
        BlocListener<EditSemesterBloc, EditSemesterState>(
          listenWhen: (pre, current) => pre.semester != current.semester,
          listener: (context, state) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeProvider(
                    userDetailsModel: userDetailsModel,
                  ),
                ),
                (Route<dynamic> route) => false);
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: EditSemesterAppBar(
            name: userDetailsModel.name,
            onBack: () {
              showDialog(
                context: context,
                builder: (context) {
                  return EditSemesterCustomAlertDialog(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onConfirm: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
              );
              //Navigator.pop(context);
            },
            onDelete: () {},
          ),
          body: BlocBuilder<EditSemesterBloc, EditSemesterState>(
            builder: (context, state) {
              if (state.loading == true) {
                return LoadingScreen();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: WillPopScope(
                    onWillPop: () async => showDialog(
                        context: context,
                        builder: (context) {
                          return EditSemesterCustomAlertDialog(
                            onCancel: () {
                              Navigator.of(context).pop(false);
                            },
                            onConfirm: () {
                              Navigator.of(context).pop(true);
                              Navigator.pop(context);
                            },
                          );
                        }),
                    child: EditSemesterPage(
                      semesterName: semester,
                      userDetailsModel: userDetailsModel,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
