import 'package:flutter/material.dart';

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1600);

  CustomPageRoute({builder}) : super(builder: builder);


}