import 'package:cozy_for_mom_frontend/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 한국어 로케일을 사용하기 위해 추가
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';

void main() {
  initializeDateFormatting('ko_KR', null).then((_) {
    // 'ko_KR'는 한국어 로케일
    runApp(ChangeNotifierProvider(
        create: (context) => MyDataModel(), child: const App()));
  });
}
