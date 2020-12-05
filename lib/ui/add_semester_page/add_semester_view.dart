import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../db/model/user_details_model.dart';
import '../../util/ui_util/custom_alert_dialog.dart';
import '../../util/ui_util/custom_app_bar.dart';
import '../home_page/home_exports.dart';
import 'add_semester_bloc.dart';
import 'add_semester_state.dart';
import 'page/add_semester_page.dart';

// ignore: must_be_immutable
class AddSemesterView extends StatelessWidget {
  static final log = Log("AddSemesterView");

  final UserDetailsModel userDetailsModel;
  final String semesterName;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AddSemesterView(
      {Key key, @required this.userDetailsModel, @required this.semesterName})
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
        BlocListener<AddSemesterBloc, AddSemesterState>(
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
          appBar: CustomAppBar(
            name: userDetailsModel.name,
            onBack: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
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
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: WillPopScope(
              onWillPop: () async => showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      onCancel: () {
                        Navigator.of(context).pop(false);
                      },
                      onConfirm: () {
                        Navigator.of(context).pop(true);
                        Navigator.pop(context);
                      },
                    );
                  }),
              child: AddSemesterPage(
                semesterName: semesterName,
                userDetailsModel: userDetailsModel,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
