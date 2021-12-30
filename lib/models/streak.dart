import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/models/makerspace_user.dart';

class Streak {
  //DateTime updatedOn;
  int count;

  Streak(this.count);

  Streak.fromJson(Map<String, dynamic> json) : count = json["count"] ?? 0;

  Map<String, dynamic> toJson() => {
        'count': this.count,
      };
}
