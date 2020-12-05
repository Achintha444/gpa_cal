import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';
import 'package:gpa_cal/ui/home_page/page/home_page.dart';
import 'package:gpa_cal/ui/home_page/widgets/home_error_widget.dart';
import 'package:gpa_cal/ui/home_page/widgets/home_first_interface.dart';
import 'package:gpa_cal/util/ui_util/custom_app_bar.dart';
import 'package:gpa_cal/util/ui_util/loading_screen.dart';

import 'home_bloc.dart';
import 'home_state.dart';

class HomeView extends StatelessWidget {
  static final log = Log("HomeView");
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  final UserDetailsModel userDetailsModel;

  const HomeView({Key key, @required this.userDetailsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log.d("Loading Home View");

    log.d(userDetailsModel.name);
    log.d(userDetailsModel.uni);
    log.d(userDetailsModel.gpaType.toString());

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
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
          appBar: CustomAppBar(name: userDetailsModel.name),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.error.isNotEmpty) {
                return HomeErrorWidget(
                  error: state.error,
                );
              } else if (state.loading) {
                return LoadingScreen();
              } else if (state.cacheNotPresent) {
                return HomeFirstInterface(userDetailsModel: userDetailsModel);
              } else if (state.userResultModel != null) {
                return HomePage(
                  userResultModel: state.userResultModel,
                  userDetailsModel: userDetailsModel,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
