import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../util/cache_util.dart';
import '../../util/db_util/gpa_conversion.dart';
import '../../util/db_util/repo.dart';
import '../../util/errors.dart';
import '../model/semester.dart';
import '../model/user_result.dart';

class EditSemesterRepo extends Repo {
  Future<void> editSemester(Semester semester) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userResults = _prefs.getString(USER_RESULTS);

      print('USER_RESULTS Cache Present');
      print('Cache present ' + semester.hash.toString() + ' edited');

      UserResultModel _userResultModel =
          UserResultModel.fromJson(json.decode(_userResults));

      int _index = _userResultModel.semesters.indexWhere(
        (sem) {
          print(sem['hash']);
          return sem['hash'] == semester.hash;
        },
      );

      var _oldSemester = _userResultModel.semesters[_index];

      var _carrerResult = _userResultModel.carrerResult - _oldSemester['totalResult'] + semester.totalResult;
      var _carrerCredit = _userResultModel.carrerCredit- _oldSemester['totalCredit'] + semester.totalCredit;
      var _cgpa = GpaConversion.returnCgpa(_carrerResult, _carrerCredit);
      
      _userResultModel.semesters[_index] = semester;
      var _semesters = _userResultModel.semesters;

      _userResultModel = new UserResultModel(
        cgpa: _cgpa,
        carrerResult: _carrerResult,
        carrerCredit: _carrerCredit,
        semesters: _semesters,
      );

      _prefs.setString(USER_RESULTS, json.encode(_userResultModel.toJson()));
      //return _userResultModel;

    } on CacheNotPresentError {
      throw (CacheNotPresentError());
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
