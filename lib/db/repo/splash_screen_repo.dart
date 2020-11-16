import 'package:gpa_cal/util/cache_util.dart';
import 'package:gpa_cal/util/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/db_util/repo.dart';

class SplashScreenRepo extends Repo {
  Future<void> autoChange() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _userDetails = _prefs.getString(USER_DETAILS);

      if (_userDetails == null){
        throw (CacheNotPresentError());
      } else{
        print ('Cache Present');
      }
    } on CacheNotPresentError {
      throw (CacheNotPresentError());
    }
    catch (e)  {
      print (e);
      throw (CacheError());
    }
  }
}
