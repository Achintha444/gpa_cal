import 'dart:convert';

import 'package:gpa_cal/db/model/user_details_model.dart';
import 'package:gpa_cal/util/cache_util.dart';
import 'package:gpa_cal/util/db_util/repo.dart';
import 'package:gpa_cal/util/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashFormRepo extends Repo {
  /// saving user details locally, if fails throws [CacheError], which normally
  /// means not enough space in local storage
  Future<void> insertUserDetails(UserDetailsModel userDetailsModel) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(USER_DETAILS, json.encode(userDetailsModel.toJson()));
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
