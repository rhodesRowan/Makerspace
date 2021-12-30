import 'dart:convert';

import 'package:makerspace/models/makerspace_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:makerspace/models/makerspace_user.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageProvider extends ChangeNotifier {
  final LocalStorage storage = new LocalStorage('makerspace_app_storage');

  MakerspaceUser? user;

  void setItem(String key, dynamic value) {
    storage.setItem(key, value);
    notifyListeners();
  }

  void setCurrentUser(MakerspaceUser user) {
    storage.setItem("current_user", json.encode(user.toJson()));
    print("Got User");
    this.user = user;
    notifyListeners();
  }

  dynamic getItem(String key) {
    var item = storage.getItem(key);
    return item;
  }
}
