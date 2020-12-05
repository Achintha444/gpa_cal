import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page/home_provider.dart';
import 'page/splash_screen_form_page.dart';
import 'splash_form_bloc.dart';
import 'splash_form_state.dart';

// ignore: must_be_immutable
class SplashFormView extends StatelessWidget {
  static final log = Log("SplashFormView");
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    log.d("Loading SplashForm View");

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: MultiBlocListener(
          listeners: [
            /// Error Bloc Listner
            BlocListener<SplashFormBloc, SplashFormState>(
              listenWhen: (pre, current) => pre.error != current.error,
              listener: (context, state) {
                if (state.error?.isNotEmpty ?? false) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                      content: Text(state.error),
                      action: SnackBarAction(
                        label: 'CLEAR',
                        onPressed: () {
                          Scaffold.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                }
              },
            ),

            /// Bloc listner that will load loading screen
            BlocListener<SplashFormBloc, SplashFormState>(
              listenWhen: (pre, current) =>
                  pre.formLoading != current.formLoading,
              listener: (context, state) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Your Details are Saving...'),
                  ),
                );
              },
            ),

            /// Bloc listner that will load the next screen
            BlocListener<SplashFormBloc, SplashFormState>(
              listenWhen: (pre, current) =>
                  pre.userDetailsModel != current.userDetailsModel,
              listener: (context, state) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeProvider(
                        userDetailsModel: state.userDetailsModel,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
          child: SplashScreenFormPage(),
        ),
      ),
    );
  }
}
