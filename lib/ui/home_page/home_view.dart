import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../db/model/user_details_model.dart';
import '../../util/ui_util/custom_app_bar.dart';
import '../../util/ui_util/loading_screen.dart';
import 'home_bloc.dart';
import 'home_provider.dart';
import 'home_state.dart';
import 'page/home_page.dart';
import 'widgets/home_error_widget.dart';
import 'widgets/home_first_interface.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  static final log = Log("HomeView");
  GlobalKey<ScaffoldState> _scaffoldKeyHome = new GlobalKey<ScaffoldState>();

  final UserDetailsModel userDetailsModel;

  HomeView({Key key, @required this.userDetailsModel}) : super(key: key);

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
              _scaffoldKeyHome.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text(state.error),
                  action: SnackBarAction(
                    label: 'CLEAR',
                    onPressed: () {
                      _scaffoldKeyHome.currentState.hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (pre, current) =>
              pre.deleteSemester != current.deleteSemester,
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
      child: Scaffold(
        key: _scaffoldKeyHome,
        appBar: CustomAppBar(
          name: userDetailsModel.name,
          university: userDetailsModel.uni,
        ),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.error.isNotEmpty) {
                return HomeErrorWidget(
                  error: state.error,
                  userDetailsModel: userDetailsModel,
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
