import 'dart:core';

import 'package:basic_utils/basic_utils.dart';

extension FormValidators on String {
  String? nameValidator() {
    if (this.isEmpty) {
      return "Please enter your name";
    }
    return null;
  }

  String? emailValidator() {
    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp emailRegex = RegExp(emailPattern);

    if (this.isEmpty) {
      return "Please enter your email address";
    } else {
      return emailRegex.hasMatch(this)
          ? null
          : "Please enter a valid email address";
    }
  }

  String? passwordValidator() {
    if (this.isEmpty) {
      return "Please enter a valid password";
    } else {
      return this.length > 6
          ? null
          : "Password needs to be at least 6 characters";
    }
  }

  String? socialHandleValidator() {
    if (this.isEmpty) {
      return "Please enter your username";
    }

    if (!this.startsWith("@", 0)) {
      StringUtils.addCharAtPosition(this, "@", 0);
    }

    String twitterHandlePattern = r'^@(?=.*\w)[\w]{1,15}$';
    RegExp twitterRegex = RegExp(twitterHandlePattern);

    return twitterRegex.hasMatch(this) ? null : "Please enter a valid username";
  }

  String? urlValidator() {
    var urlPattern =
        r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
    RegExp urlRegex = RegExp(urlPattern);

    return urlRegex.hasMatch(this) ? null : "Please enter a valid url";
  }

  String? isNotEmptyString() {
    return (this.isEmpty) ? "Please enter" : null;
  }

  String? confirmPasswordValidator(String? confirmationValue) {
    return this == confirmationValue ? null : "Passwords don't match";
  }
}
