import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_form_bloc.dart';
import 'splash_form_view.dart';

class SplashFormProvider extends BlocProvider<SplashFormBloc> {
  SplashFormProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => SplashFormBloc(context),
          child: SplashFormView(),
        );
}
