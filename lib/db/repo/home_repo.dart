import 'dart:convert';

import 'package:gpa_cal/db/model/user_result.dart';
import 'package:gpa_cal/util/cache_util.dart';
import 'package:gpa_cal/util/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/db_util/repo.dart';

class HomeRepo extends Repo {
  Future<UserResultModel> firstInterfaceCheck() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userResults = _prefs.getString(USER_RESULTS);
      print (_userResults);

      if (_userResults == null) {
        throw (CacheNotPresentError());
      } else {
        print('USER_RESULTS Cache Present');
        return UserResultModel.fromJson(json.decode(_userResults));
      }
    } on CacheNotPresentError {
      throw (CacheNotPresentError());
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
