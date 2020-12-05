import 'package:flutter/material.dart';

import '../../util/db_util/model.dart';

class Semester extends Model {
  int hash;
  String name;
  double sgpa;
  double totalResult;
  double totalCredit;
  List subjectList;

  Semester({
    @required this.hash,
    @required this.name,
    @required this.sgpa,
    @required this.totalResult,
    @required this.totalCredit,
    @required this.subjectList,
  });

  static Semester fromJson(Map<String, dynamic> json) {
    return Semester(
      hash: json['hash'],
      name: json['name'],
      sgpa: json['sgpa'],
      subjectList: json['subjectList'],
      totalCredit: json['totalCredit'],
      totalResult: json['totalResult'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'hash': this.hash,
      'name': this.name,
      'sgpa': this.sgpa,
      'subjectList': this.subjectList,
      'totalCredit' : this.totalCredit,
      'totalResult': this.totalResult,
    };
  }
}
