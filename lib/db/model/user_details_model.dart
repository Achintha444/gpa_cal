import 'package:flutter/widgets.dart';

import '../../util/db_util/model.dart';

class UserDetailsModel extends Model<UserDetailsModel> {
  String name;
  String uni;

  /// 0 -> 4.0 and 1 -> 4.2
  int gpaType;

  UserDetailsModel({
    @required this.name,
    @required this.uni,
    @required this.gpaType,
  });

  static UserDetailsModel fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      name: json['name'],
      uni: json['uni'],
      gpaType: json['gpaType'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name' : this.name,
      'uni': this.uni,
      'gpaType': this.gpaType
    };
  }
}
