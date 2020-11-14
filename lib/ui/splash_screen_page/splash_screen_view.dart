import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/ui/splash_screen_page/page/splash_screen_page.dart';

import 'splash_screen_bloc.dart';
import 'splash_screen_state.dart';

class SplashScreenView extends StatelessWidget {
  static final log = Log("SplashScreenView");
  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

   static final  scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final splash_screenBloc = BlocProvider.of<SplashScreenBloc>(context);
    // ignore: close_sinks
    log.d("Loading SplashScreen View");

    CustomSnackBar customSnackBar = new CustomSnackBar(scaffoldKey: scaffoldKey);

    return MultiBlocListener(
      listeners: [
        BlocListener<SplashScreenBloc, SplashScreenState>(
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
      child: SplashScreenPage(key: scaffoldKey,),
    );
  }
}
