import 'package:cozy_for_mom_frontend/app.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/service/user/device_token_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// 한국어 로케일을 사용하기 위해 추가
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/configs/.env');
  await initializeNotifications();
  await DeviceTokenManager().initialize();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT_APP_KEY']!,
  );

  // 'ko_KR'는 한국어 로케일
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
}

Future<void> initializeNotifications() async {
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
         requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (payload != null && payload.isNotEmpty) {
        await onSelectNotification(payload);
      } else {
        print('No payload found in notification response');
      }
    },
  );

  // test 알림 보내기
  NotificationDetails details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
     
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      "타이틀이 보여지는 영역입니다.",
      "컨텐츠 내용이 보여지는 영역입니다.\ntest show()",
      details,
      payload: "/main_screen",
    );
}

Future<void> onSelectNotification(String payload) async {
  navigatorKey.currentState!.pushNamed(payload);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
