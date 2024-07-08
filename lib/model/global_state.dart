import 'package:flutter/foundation.dart';

// TODO 전역으로 상태 관리 필요한 변수는 이 클래스에서 관리
class MyDataModel with ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  int selectedProfileId = 0;

  DateTime get selectedDay => selectedDate;

  void updateSelectedDay(DateTime newDay) {
    selectedDate = newDay;
    notifyListeners();
  }

  void setSelectedProfileId(int id) {
    selectedProfileId = id;
    notifyListeners();
  }

  int? getSelectedProfileId() {
    return selectedProfileId;
  }
}
