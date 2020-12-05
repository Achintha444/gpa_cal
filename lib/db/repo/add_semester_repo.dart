import 'dart:convert';

import 'package:gpa_cal/db/model/semester.dart';
import 'package:gpa_cal/db/model/user_result.dart';
import 'package:gpa_cal/util/cache_util.dart';
import 'package:gpa_cal/util/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/db_util/repo.dart';

class AddSemesterRepo extends Repo {
  Future<UserResultModel> addSemesterLocally(Semester semester) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userResults = _prefs.getString(USER_RESULTS);
      if (_userResults == null) {
        print ('Cache not present '+semester.hash.toString()+' added');
        var _userResultsModel = new UserResultModel(
          cgpa: semester.sgpa,
          carrerResult: semester.totalResult,
          carrerCredit: semester.totalCredit,
          semesters: [semester.toJson()],
        );
        _prefs.setString(USER_RESULTS, json.encode(_userResultsModel.toJson()));
        return _userResultsModel;
      } else {
        print('Cache Present');
      }
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
