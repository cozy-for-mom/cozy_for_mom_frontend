import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/service/user/oauth_api_service.dart';
import 'package:flutter/material.dart';

class JoinInputData extends ChangeNotifier {
  String email = '';
  String name = '';
  String birth = '';
  String nickname = '';
  String dueDate = '';
  String laseMensesDate = '';
  String fetalInfo = '단태아';
  List<String> birthNames = [];
  List<String> genders = [];
  List<Baby> babies = [];
  OauthType oauthType = OauthType.none;

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

  void setBirthname(int index, String value) {
    if (index >= birthNames.length) {
      birthNames.add(value);
    } else {
      birthNames[index] = value;
    }
  }

  void setGender(int index, String value) {
    if (index >= genders.length) {
      genders.add(value);
    } else {
      genders[index] = value;
    }
  }

  void addBaby(Baby baby) {
    babies.add(baby);
    notifyListeners();
  }

  void setOauthType(OauthType type) {
    oauthType = type;
  }
}
