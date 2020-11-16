import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_form_bloc.dart';
import 'splash_form_state.dart';

class SplashFormView extends StatelessWidget {
  static final log = Log("SplashFormView");
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    log.d("Loading SplashForm View");

    return Scaffold(
      key: _scaffoldKey,
      body: MultiBlocListener(
        listeners: [
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
        ],
        child: Container(),
      ),
    );
  }
}
