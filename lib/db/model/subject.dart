import 'package:flutter/material.dart';
import 'package:gpa_cal/util/db_util/model.dart';

class Subject extends Model {
  String course;
  String result;
  int credit;

  Subject({
    @required this.course,
    @required this.result,
    @required this.credit,
  });

  static Subject fromJson(Map<String, dynamic> json) {
    return Subject(
      course: json['course'],
      result: json['result'],
      credit: json['credit'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'course': this.course,
      'result': this.result,
      'credit': this.result
    };
  }
}
