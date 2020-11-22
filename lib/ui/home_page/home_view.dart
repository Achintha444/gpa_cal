import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';

import 'home_bloc.dart';
import 'home_state.dart';

class HomeView extends StatelessWidget {
  static final log = Log("HomeView");
  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final UserDetailsModel userDetailsModel;

  const HomeView({Key key, @required this.userDetailsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log.d("Loading Home View");

    log.d(userDetailsModel.name);
    log.d(userDetailsModel.uni);
    log.d(userDetailsModel.gpaType.toString());

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (pre, current) => true,
          builder: (context, state) {
            return Center(
              child: Text("HI..."),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
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
