import 'package:flutter/material.dart';

class JoinInputData extends ChangeNotifier {
  String email = '';
  String name = '';
  String birth = '';
  String nickname = '';

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setBirth(String value) {
    birth = value;
    notifyListeners();
  }

  void setNickname(String value) {
    nickname = value;
    notifyListeners();
  }
}
