import 'package:cozy_for_mom_frontend/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 한국어 로케일을 사용하기 위해 추가
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/service/mom_supplement_api_service.dart';

void main() {
  initializeDateFormatting('ko_KR', null).then((_) {
    // 'ko_KR'는 한국어 로케일
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyDataModel()),
          ChangeNotifierProvider(create: (context) => ListModifyState()),
          // ChangeNotifierProvider(create: (context) => JoinInputData()), // TODO 회원가입 (정보입력) 페이지 연동 후, 주석 해제
          ChangeNotifierProvider(create: (context) => SupplementApiService()),
        ],
        child: const App(),
      ),
    );
  });
}
