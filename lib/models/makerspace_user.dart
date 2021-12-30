import 'package:json_annotation/json_annotation.dart';
import 'package:makerspace/models/streak.dart';

//part 'makerspace_user.dart';

@JsonSerializable()
class MakerspaceUser {
  String id;
  String displayName;
  String email;
  String? photoUrl;
  Streak? streak;
  String? bio;
  String? indieHackersHandle;
  String? website;
  String? twitterHandle;

  MakerspaceUser(String id, Map<String, dynamic> json, Streak streak)
      : this.id = id,
        this.displayName = json['displayName'],
        this.email = json['email'] as String,
        this.photoUrl = json["photoUrl"],
        this.streak = streak,
        this.bio = json["bio"],
        this.website = json["website"],
        this.indieHackersHandle = json["indieHackersHandle"],
        this.twitterHandle = json["twitterHandle"];

  MakerspaceUser.fromJson(Map<String, dynamic> json)
      : this.id = json["id"],
        this.displayName = json["displayName"],
        this.email = json["email"],
        this.photoUrl = json["photoUrl"],
        this.streak = json.containsKey("streak") ? Streak.fromJson(json["streak"]) : null,
        this.bio = json["bio"],
        this.website = json["website"],
        this.indieHackersHandle = json["indie_hackers_handle"],
        this.twitterHandle = json["twitter_handle"];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'displayName': this.displayName,
        'email': this.email,
        'photoUrl': this.photoUrl,
        'streak': this.streak?.toJson(),
        'bio': this.bio,
        'website': this.website,
        'indie_hackers_handle': this.indieHackersHandle,
        'twitter_handle': this.twitterHandle
      };
}
