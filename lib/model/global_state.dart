import 'package:flutter/foundation.dart';

// TODO 전역으로 상태 관리 필요한 변수는 이 클래스에서 관리
class MyDataModel with ChangeNotifier {
  Map<String, String> bloodSugarData = {}; // 시간대와 혈당 수치 매핑
  int selectedProfileId = 0;

  void setBloodSugarData(String time, String value) {
    bloodSugarData[time] = value;
    notifyListeners();
  }

  String? getBloodSugarData(String time) {
    return bloodSugarData[time];
  }

  void setSelectedProfileId(int id) {
    selectedProfileId = id;
    notifyListeners();
  }

  int? getSelectedProfileId() {
    return selectedProfileId;
  }
}
