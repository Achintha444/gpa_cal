import 'dart:convert';

import 'package:gpa_cal/db/model/user_details_model.dart';
import 'package:gpa_cal/util/cache_util.dart';
import 'package:gpa_cal/util/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/db_util/repo.dart';

class SplashScreenRepo extends Repo {
  Future<UserDetailsModel> autoChange() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userDetails = _prefs.getString(USER_DETAILS);

      if (_userDetails == null) {
        throw (CacheNotPresentError());
      } else {
        print('Cache Present');
        //await _prefs.remove(USER_DETAILS);
        return UserDetailsModel.fromJson(
          json.decode(_userDetails),
        );
      }
    } on CacheNotPresentError {
      throw (CacheNotPresentError());
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
