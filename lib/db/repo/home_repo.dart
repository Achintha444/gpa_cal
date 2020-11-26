import 'package:gpa_cal/util/cache_util.dart';
import 'package:gpa_cal/util/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/db_util/repo.dart';

class HomeRepo extends Repo {
  Future<void> firstInterfaceCheck() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userResults = _prefs.getString(USER_RESULTS);

      if (_userResults == null) {
        throw (CacheNotPresentError());
      } else {
        print('Cache Present');
      }
    } on CacheNotPresentError {
      throw (CacheNotPresentError());
    } catch (e) {
      print(e);
      throw (CacheError());
    }
  }
}
