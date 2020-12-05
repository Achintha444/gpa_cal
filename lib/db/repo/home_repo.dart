import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../util/cache_util.dart';
import '../../util/db_util/gpa_conversion.dart';
import '../../util/db_util/repo.dart';
import '../../util/errors.dart';
import '../model/semester.dart';
import '../model/user_result.dart';

class HomeRepo extends Repo {
  Future<UserResultModel> firstInterfaceCheck() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userResults = _prefs.getString(USER_RESULTS);
      print(_userResults);

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

  Future<void> deleteSemester(Semester semester) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userResults = _prefs.getString(USER_RESULTS);

      print('USER_RESULTS Cache Present');
      print('Cache present ' + semester.hash.toString() + ' removed');

      UserResultModel _userResultModel =
          UserResultModel.fromJson(json.decode(_userResults));

      if (_userResultModel.semesters.length == 1) {
        await _prefs.remove(USER_RESULTS);
      } else {
        print (_userResultModel.semesters[0]['hash']);
        _userResultModel.semesters.removeWhere(
          (sem) {
            print (sem['hash']);
            return sem['hash'] == semester.hash;
          },
        );
        var _semesters = _userResultModel.semesters;
        var _carrerResult =
            _userResultModel.carrerResult - semester.totalResult;
        var _carrerCredit =
            _userResultModel.carrerCredit - semester.totalCredit;
        var _cgpa = GpaConversion.returnCgpa(_carrerResult, _carrerCredit);

        _userResultModel = new UserResultModel(
          cgpa: _cgpa,
          carrerResult: _carrerResult,
          carrerCredit: _carrerCredit,
          semesters: _semesters,
        );

        _prefs.setString(USER_RESULTS, json.encode(_userResultModel.toJson()));
        //return _userResultModel;
      }
    } on CacheNotPresentError {
      throw (CacheNotPresentError());
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
