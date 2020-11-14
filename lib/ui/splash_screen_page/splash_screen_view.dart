import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/ui/splash_screen_page/page/splash_screen_page.dart';

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
    final splash_screenBloc = BlocProvider.of<SplashScreenBloc>(context);
    // ignore: close_sinks
    log.d("Loading SplashScreen View");

    return Scaffold(
      key: _scaffoldKey,
      body: MultiBlocListener(
        listeners: [
          BlocListener<SplashScreenBloc, SplashScreenState>(
            listenWhen: (pre, current) => pre.error != current.error,
            listener: (context, state) {
              print(state.error);
              if (state.error?.isNotEmpty ?? false) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).errorColor,
                    content: Text(state.error),
                    duration: Duration(days: 1),
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
        ],
        child: SplashScreenPage(),
      ),
    );
  }
}
