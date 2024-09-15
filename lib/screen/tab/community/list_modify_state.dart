import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:flutter/material.dart';

class ListModifyState extends ChangeNotifier {
  int get selectedCount => _selectedIds.length;

  List<int> _selectedIds = [];
  List<int> get selectedIds => _selectedIds;

  bool isSelected(int id) {
    return _selectedIds.contains(id);
  }

  void toggleSelected(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }

    notifyListeners();
  }

  void setCozylogAllSelected(List<int> ids) {
    _selectedIds = ids.map((id) => id).toList();
    notifyListeners();
  }

  void setGrowthAllSelected(List<int> ids) {
    _selectedIds = ids.map((id) => id).toList();
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }
}
