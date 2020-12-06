class GpaConversion {
  /// Result list of 4.2 ([gpaType = 1])
  static final List<String> resultList1 = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C',
    'C+',
    'C-',
    'D',
    'I-we',
    'F'
  ];

  /// Result list of 4.2 ([gpaType = 0])
  static final List<String> resultList0 = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C',
    'C+',
    'C-',
    'D+',
    'D',
    'E',
    'I-we',
    'F'
  ];

  /// Gpa list of 4.0 ([gpaType = 0])
  static final Map<String, double> gpa0 = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1,
    'E': 0,
    'I-we': 0,
    'F': 0
  };

  /// Gpa list of 4.2 ([gpaType = 1])
  static final Map<String, double> gpa1 = {
    'A+': 4.2,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2,
    'C-': 1.5,
    'D': 1,
    'I-we': 0,
    'F': 0
  };

  static double returnSgpa(Map totalResult, Map totalCredit, int gpaType) {
    var _gpa = gpaType == 1 ? gpa1 : gpa0;
    var _totCredit = 0.0;
    totalCredit.forEach((key, credit) {
      var credit1 = credit.toString();
      if (credit1.trim().isNotEmpty) {
        _totCredit += (double.parse(credit1));
      }
    });

    if (_totCredit == 0) {
      return 0.0;
    } else {
      var _totResult = 0.0;
      totalResult.forEach((key, result) {
        var x = result[1].toString();
        if (x.trim().isNotEmpty) {
          _totResult += (_gpa[result[0]] * double.parse(x));
        }
      });
      return double.parse((_totResult / _totCredit).toStringAsPrecision(3));
    }
  }

  static double returnCgpa(double totalResult, double totalCredit) {
    return  double.parse((totalResult / totalCredit).toStringAsPrecision(3));
  }
}
