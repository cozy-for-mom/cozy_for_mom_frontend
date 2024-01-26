import 'package:flutter/material.dart';

class JoinInputData extends ChangeNotifier {
  String email = '';
  String name = '';
  String birth = '';
  String nickname = '';
  String dueDate = '';
  String laseMensesDate = '';
  String? fetalInfo;
  String? gender;
  String birthName = '';

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

  void setDueDate(String value) {
    dueDate = value;
    notifyListeners();
  }

  void setLastMensesDate(String value) {
    laseMensesDate = value;
    notifyListeners();
  }

  void setFetalInfo(String? value) {
    if (value != null) {
      fetalInfo = value;
    }
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setBirthname(String value) {
    birthName = value;
    notifyListeners();
  }
}
