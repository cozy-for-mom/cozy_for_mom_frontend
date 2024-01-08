import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/model/cozylog_model.dart';

class ListModifyState extends ChangeNotifier {
  int _selectedCount = 0;
  int get selectedCount => _selectedCount;

  List<int> _selectedIds = [];
  List<int> get selectedIds => _selectedIds;

  bool isSelected(int id) {
    return _selectedIds.contains(id);
  }

  void toggleSelected(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      _selectedCount--;
    } else {
      _selectedIds.add(id);
      _selectedCount++;
    }

    notifyListeners();
  }

  void setAllSelected(List<CozyLog> cozyLogs) {
    _selectedIds = cozyLogs.map((cozyLog) => cozyLog.id).toList();
    _selectedCount = cozyLogs.length;
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    _selectedCount = 0;
    notifyListeners();
  }
}
