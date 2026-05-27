
import '../../util/db_util/model.dart';

class UserResultModel extends Model {
  final double cgpa;
  final double carrerResult;
  final double carrerCredit;
  final List<dynamic> semesters;

  UserResultModel({
    required this.cgpa,
    required this.carrerResult,
    required this.carrerCredit,
    required this.semesters,
  });

  static UserResultModel fromJson(Map<String, dynamic> json) {
    return UserResultModel(
      cgpa: json['cgpa'],
      carrerCredit: json['carrerCredit'],
      carrerResult: json['carrerResult'],
      semesters: json['semesters'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'cgpa': this.cgpa,
      'carrerResult': this.carrerResult,
      'carrerCredit': this.carrerCredit,
      'semesters': this.semesters
    };
  }
}
