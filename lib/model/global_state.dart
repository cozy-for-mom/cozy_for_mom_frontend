import 'package:flutter/foundation.dart';

class MyDataModel with ChangeNotifier {
  Map<String, String> bloodSugarData = {}; // 시간대와 혈당 수치 매핑

  void setBloodSugarData(String time, String value) {
    bloodSugarData[time] = value;
    notifyListeners();
  }
}
