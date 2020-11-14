import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_screen_bloc.dart';
import 'splash_screen_view.dart';

class SplashScreenProvider extends BlocProvider<SplashScreenBloc> {
  SplashScreenProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => SplashScreenBloc(context),
          child: SplashScreenView(),
        );
}
