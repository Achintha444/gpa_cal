import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/ui_util/custom_page_route.dart';
import '../home_page/home_exports.dart';
import '../splash_form_page/splash_form_exports.dart';
import 'page/splash_screen_page.dart';
import 'splash_screen_bloc.dart';
import 'splash_screen_state.dart';

class SplashScreenView extends StatelessWidget {
  static final log = Log("SplashScreenView");
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    //final splash_screenBloc = BlocProvider.of<SplashScreenBloc>(context);
    // ignore: close_sinks
    log.d("Loading SplashScreen View");

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: MultiBlocListener(
          listeners: [
            /// This listner called in case of an error
            BlocListener<SplashScreenBloc, SplashScreenState>(
              listenWhen: (pre, current) => pre.error != current.error,
              listener: (context, state) {
                print(state.cacheNotPresent);
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

            /// This is called for the very first time app opens
            BlocListener<SplashScreenBloc, SplashScreenState>(
              listenWhen: (pre, current) => current.cacheNotPresent == true,
              listener: (context, state) {
                Navigator.pushAndRemoveUntil(
                    context,
                    CustomPageRoute(
                      builder: (context) => SplashFormProvider(),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),

            /// Auto moving to the home screen
            BlocListener<SplashScreenBloc, SplashScreenState>(
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
          child: SplashScreenPage(),
        ),
      ),
    );
  }
}
