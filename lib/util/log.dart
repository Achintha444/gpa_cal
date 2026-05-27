import 'dart:developer' as developer;

class Log {
  final String tag;

  Log(this.tag);

  void d(String message) {
    developer.log(message, name: tag);
  }

  void e(String message) {
    developer.log(message, name: tag, level: 1000); // 1000 represents Severe / Error level
  }
}
