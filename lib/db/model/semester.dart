import 'package:flutter/material.dart';

import '../../util/db_util/model.dart';
import 'subject.dart';

class Semester extends Model {
  String semester;
  double sgpa;
  List<Subject> subjectList;

  Semester({
    @required this.semester,
    @required this.sgpa,
    @required this.subjectList,
  });

  static Semester fromJson(Map<String, dynamic> json) {
    return Semester(
      semester: json['semester'],
      sgpa: json['sgpa'],
      subjectList: json['subjectList'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'semester': this.semester,
      'sgpa': this.sgpa,
      'subjectList': this.subjectList
    };
  }
}
