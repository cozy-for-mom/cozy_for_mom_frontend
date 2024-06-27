import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorageService {
  static UserLocalStorageService? _instance;
  SharedPreferences? _prefs; // SharedPreferences 인스턴스

  // 싱글톤 생성자
  UserLocalStorageService._internal();

  // 싱글톤 인스턴스 생성자
  static Future<UserLocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = UserLocalStorageService._internal(); // 인스턴스 생성
      _instance!._prefs =
          await SharedPreferences.getInstance(); // SharedPreferences 초기화
    }
    return _instance!;
  }

  Future<void> setUser(User user) async {
    await _prefs!.setInt('babyProfileId', user.babyProfile.babyProfileId);
    await _prefs!.setStringList('babyIds', user.babyProfile.babies.map((e) => e.babyId.toString()).toList());
    await _prefs!.setStringList('babyNames', user.babyProfile.babies.map((e) => e.babyName.toString()).toList());
    await _prefs!.setString('nickname', user.nickname);
  }

  Future<int?> getBabyProfileId() async {
    if (_prefs!.getInt('babyProfileId') != null) {
     return _prefs!.getInt('babyProfileId')!;
    } else {
      return null;
    }
  }

  Future<List<int>?> getBabyIds() async {
    return _prefs!.getStringList('babyIds')!.map((e) => int.parse(e)).toList();
  }

  Future<List<String>?> getBabyNames() async {
    return _prefs!.getStringList('babyNames');
  }
}
