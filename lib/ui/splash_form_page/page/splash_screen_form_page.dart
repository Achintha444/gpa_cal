import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/theme/project_theme.dart';
import 'package:gpa_cal/ui/splash_form_page/splash_form_bloc.dart';
import 'package:gpa_cal/ui/splash_form_page/splash_form_event.dart';

import '../../../util/ui_util/gpa_cal_main_button.dart';
import '../widgets/splash_form_title_text.dart';

class SplashScreenFormPage extends StatefulWidget {
  @override
  _SplashScreenFormPageState createState() => _SplashScreenFormPageState();
}

class _SplashScreenFormPageState extends State<SplashScreenFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _uni;

  /// 0 -> 4.0 and 1 -> 4.2
  int _gpaType = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: EdgeInsets.all(24),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Hero(
            tag: 'HeroLogo',
            child: Container(
              height: 216,
              child: Image(
                image: AssetImage('graphics/logo.png'),
              ),
            ),
          ),
          SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                //* Name text form field
                SplashFormTitleText(title: 'Enter Your Name'),
                SizedBox(height: 16),
                TextFormField(
                  decoration: this._inputDecoration('Name'),
                  style: this._inputTextStyle(),
                  validator: (value) {
                    return this._emptyValidator(value, 'Name');
                  },
                  onChanged: (value) {
                    this._name = value;
                  },
                ),
                SizedBox(height: 24),

                //* University text form field
                SplashFormTitleText(title: 'Enter Your University (or School)'),
                SizedBox(height: 16),
                TextFormField(
                  decoration: this._inputDecoration('University/School'),
                  style: this._inputTextStyle(),
                  validator: (value) {
                    return this._emptyValidator(value, 'University');
                  },
                  onChanged: (value) {
                    this._uni = value;
                  },
                ),
                SizedBox(height: 24),

                //* GPA radio buttons
                SplashFormTitleText(title: 'Select the GPA Type'),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text(
                          '4.2',
                          style: _radioButtonTextStyle(),
                        ),
                        leading: Radio(
                          value: 1,
                          groupValue: _gpaType,
                          onChanged: (value) {
                            setState(() {
                              _gpaType = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          '4.0',
                          style: _radioButtonTextStyle(),
                        ),
                        leading: Radio(
                          value: 0,
                          groupValue: _gpaType,
                          onChanged: (value) {
                            setState(() {
                              _gpaType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                GpaCalMainButton(
                  text: 'Continue',
                  onClick: () {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      print(_name);
                      print(_uni);
                      print(_gpaType);

                      BlocProvider.of<SplashFormBloc>(context).add(
                        UserDetailsAddEvent(
                          name: _name,
                          uni: _uni,
                          gpaType: _gpaType,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// text -> onChanged value and type -> type of the text
  String _emptyValidator(String text, String type) {
    if (text.isEmpty) {
      return type + ' Cannot be Empty!';
    } else if (text.trim().isEmpty) {
      return type + ' Cannot be Empty!';
    }
    return null;
  }

  TextStyle _radioButtonTextStyle() {
    return TextStyle(fontSize: 16, color: ProjectColours.PRIMARY_COLOR);
  }

  TextStyle _inputTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding:
          const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0, right: 8),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      labelStyle: TextStyle(
        color: ProjectColours.PRIMARY_COLOR.withOpacity(0.75),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontSize: 16,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }
}
