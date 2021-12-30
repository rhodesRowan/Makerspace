import 'package:makerspace/models/makerspace_user.dart';
import 'package:makerspace/models/post.dart';

class MakerspaceNotification {
  String id;
  String text;
  bool isRead;
  MakerspaceUser user;
  Post post;

  MakerspaceNotification(this.id, this.text, this.isRead, this.user, this.post);
}
