import 'package:cozy_for_mom_frontend/app.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_bloodsugar_api_service.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_meal_api_service.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_supplement_api_service.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_weight_api_service.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/service/user/device_token_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await dotenv.load(fileName: 'assets/configs/.env'); // 이 코드를 추가한다.

  // await DeviceTokenManager().initialize();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT_APP_KEY']!,
  );

  // 'ko_KR'는 한국어 로케일
  initializeDateFormatting('ko_KR', null).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyDataModel()),
          ChangeNotifierProvider(create: (context) => ListModifyState()),
          ChangeNotifierProvider(create: (context) => JoinInputData()),
          ChangeNotifierProvider(create: (context) => SupplementApiService()),
          ChangeNotifierProvider(create: (context) => WeightApiService()),
          ChangeNotifierProvider(create: (context) => MealApiService()),
          ChangeNotifierProvider(create: (context) => BloodsugarApiService()),
          ChangeNotifierProvider(create: (context) => UserApiService())
        ],
        child: const App(),
      ),
    );
  });
}
