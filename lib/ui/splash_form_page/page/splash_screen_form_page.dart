import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/project_theme.dart';

import '../../../util/ui_util/gpa_cal_main_button.dart';
import '../widgets/splash_form_title_text.dart';

class SplashScreenFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: EdgeInsets.all(24),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                SplashFormTitleText(title: 'Enter Your Name'),
                SizedBox(height: 16),
                TextFormField(
                  decoration: this._inputDecoration('Name'),
                ),

                SizedBox(height: 24),
                
                SplashFormTitleText(title: 'Enter Your University (or School)'),
                SizedBox(height: 16),
                TextFormField(
                  decoration: this._inputDecoration('University/School'),
                ),
                
                SizedBox(height: 24),
                SplashFormTitleText(title: 'Select the GPA Type'),

                
                GpaCalMainButton(),
              ],
            ),
          ),
        ],
      ),
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
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      
    );
  }
}
