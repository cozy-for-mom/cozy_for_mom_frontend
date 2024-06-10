import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cozy_for_mom_frontend/model/user_join_model.dart';
import 'package:cozy_for_mom_frontend/service/user/oauth_api_service.dart';

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

  final _storage = FlutterSecureStorage();

  void setEmail(String value) {
    email = value;
    notifyListeners();
    _saveToStorage('email', value);
  }

  void setName(String value) {
    name = value;
    notifyListeners();
    _saveToStorage('name', value);
  }

  void setBirth(String value) {
    birth = value;
    notifyListeners();
    _saveToStorage('birth', value);
  }

  void setNickname(String value) {
    nickname = value;
    notifyListeners();
    _saveToStorage('nickname', value);
  }

  void setDueDate(String value) {
    dueDate = value;
    notifyListeners();
    _saveToStorage('dueDate', value);
  }

  void setLastMensesDate(String value) {
    laseMensesDate = value;
    notifyListeners();
    _saveToStorage('laseMensesDate', value);
  }

  void setFetalInfo(String? value) {
    if (value != null) {
      fetalInfo = value;
      _saveToStorage('fetalInfo', value);
    }
    notifyListeners();
  }

  void setBirthname(int index, String value) {
    if (index >= birthNames.length) {
      birthNames.add(value);
    } else {
      birthNames[index] = value;
    }
    _saveListToStorage('birthNames', birthNames);
  }

  void setGender(int index, String value) {
    if (index >= genders.length) {
      genders.add(value);
    } else {
      genders[index] = value;
    }
    _saveListToStorage('genders', genders);
  }

  void addBaby(Baby baby) {
    babies.add(baby);
    notifyListeners();
    _saveBabiesToStorage();
  }

  void setOauthType(OauthType type) {
    oauthType = type;
    _saveToStorage('oauthType', type.toString());
  }

  Future<void> _saveToStorage(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> _saveListToStorage(String key, List<String> list) async {
    await _storage.write(key: key, value: list.join(','));
  }

  Future<void> _saveBabiesToStorage() async {
    List<String> babyStrings =
        babies.map((baby) => baby.toJson().toString()).toList();
    await _storage.write(key: 'babies', value: babyStrings.join(';'));
  }

  Future<void> loadFromStorage() async {
    email = await _storage.read(key: 'email') ?? '';
    name = await _storage.read(key: 'name') ?? '';
    birth = await _storage.read(key: 'birth') ?? '';
    nickname = await _storage.read(key: 'nickname') ?? '';
    dueDate = await _storage.read(key: 'dueDate') ?? '';
    laseMensesDate = await _storage.read(key: 'laseMensesDate') ?? '';
    fetalInfo = await _storage.read(key: 'fetalInfo') ?? '단태아';

    String? birthNamesString = await _storage.read(key: 'birthNames');
    if (birthNamesString != null) {
      birthNames = birthNamesString.split(',');
    }

    String? gendersString = await _storage.read(key: 'genders');
    if (gendersString != null) {
      genders = gendersString.split(',');
    }

    String? babiesString = await _storage.read(key: 'babies');
    if (babiesString != null) {
      List<String> babyStrings = babiesString.split(';');
      babies =
          babyStrings.map((babyString) => Baby.fromJson(babyString)).toList();
    }

    notifyListeners();
  }
}
