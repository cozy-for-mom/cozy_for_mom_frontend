import 'package:shared_preferences/shared_preferences.dart';

class CozyLogLocalStorageService {
  static CozyLogLocalStorageService? _instance;
  SharedPreferences? _prefs; // SharedPreferences 인스턴스

  // 싱글톤 생성자
  CozyLogLocalStorageService._internal();

  // 싱글톤 인스턴스 생성자
  static Future<CozyLogLocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = CozyLogLocalStorageService._internal(); // 인스턴스 생성
      _instance!._prefs =
          await SharedPreferences.getInstance(); // SharedPreferences 초기화
    }
    return _instance!;
  }

  // 최근 검색어를 추가하는 함수
  Future<void> addRecentSearch(String searchQuery) async {
    List<String> recentSearches = _prefs!.getStringList('recentSearches') ?? [];
    recentSearches.remove(searchQuery); // 중복 제거
    recentSearches.insert(0, searchQuery); // 최신 검색어를 가장 앞에 추가
    await _prefs!.setStringList('recentSearches', recentSearches);
  }

  // 최근 검색어를 전체 삭제하는 함수
  Future<void> clearRecentSearches() async {
    await _prefs!.remove('recentSearches'); // 전체 삭제
  }

  // 특정 검색어를 삭제하는 함수
  Future<void> deleteRecentSearch(String searchQuery) async {
    List<String> recentSearches = _prefs!.getStringList('recentSearches') ?? [];
    recentSearches.remove(searchQuery); // 특정 검색어 삭제

    await _prefs!.setStringList('recentSearches', recentSearches);
  }

  // 최근 검색어를 가져오는 함수
  Future<List<String>> getRecentSearches() async {
    List<String> recentSearches = _prefs!.getStringList('recentSearches') ?? [];
    return recentSearches;
  }

  // 자동 저장 설정을 설정하는 함수
  Future<void> setAutoSave(bool isEnabled) async {
    await _prefs!.setBool('autoSave', isEnabled);
  }

  // 자동 저장 설정을 가져오는 함수
  Future<bool> getAutoSave() async {
    return _prefs!.getBool('autoSave') ?? true; // 기본적으로 자동 저장 켜기
  }
}
