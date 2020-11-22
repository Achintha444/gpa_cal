import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';

import 'home_bloc.dart';
import 'home_view.dart';

class HomeProvider extends BlocProvider<HomeBloc> {

  final UserDetailsModel userDetailsModel;

  HomeProvider({
    Key key,
    @required this.userDetailsModel
  }) : super(
          key: key,
          create: (context) => HomeBloc(context),
          child: HomeView(userDetailsModel:userDetailsModel),
        );
}
