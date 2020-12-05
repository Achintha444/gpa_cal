import 'dart:convert';

import 'package:gpa_cal/db/model/semester.dart';
import 'package:gpa_cal/db/model/user_result.dart';
import 'package:gpa_cal/util/cache_util.dart';
import 'package:gpa_cal/util/db_util/gpa_conversion.dart';
import 'package:gpa_cal/util/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/db_util/repo.dart';

class AddSemesterRepo extends Repo {
  Future<UserResultModel> addSemesterLocally(Semester semester) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userResults = _prefs.getString(USER_RESULTS);
      if (_userResults == null) {
        print('Cache not present ' + semester.hash.toString() + ' added');
        var _userResultModel = new UserResultModel(
          cgpa: double.parse(semester.sgpa.toStringAsPrecision(3)),
          carrerResult: semester.totalResult,
          carrerCredit: semester.totalCredit,
          semesters: [semester.toJson()],
        );
        _prefs.setString(USER_RESULTS, json.encode(_userResultModel.toJson()));
        return _userResultModel;
      } else {
        print('USER_RESULTS Cache Present');
        print('Cache present ' + semester.hash.toString() + ' added');

        UserResultModel _userResultModel =
            UserResultModel.fromJson(json.decode(_userResults));
        _userResultModel.semesters.add(semester);
        var _semesters = _userResultModel.semesters;
        var _carrerResult =
            _userResultModel.carrerResult + semester.totalResult;
        var _carrerCredit =
            _userResultModel.carrerCredit + semester.totalCredit;
        var _cgpa = GpaConversion.returnCgpa(_carrerResult, _carrerCredit);

        _userResultModel = new UserResultModel(
          cgpa: double.parse(_cgpa.toStringAsPrecision(3)),
          carrerResult: _carrerResult,
          carrerCredit: _carrerCredit,
          semesters: _semesters,
        );

        _prefs.setString(USER_RESULTS, json.encode(_userResultModel.toJson()));
        return _userResultModel;
      }
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
