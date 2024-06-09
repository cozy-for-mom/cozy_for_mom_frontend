import 'package:cozy_for_mom_frontend/main.dart';
import 'package:cozy_for_mom_frontend/screen/login/login_screen.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy For Mom',
      home: LoginScreen(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(), // 필요한 테마 설정
        fontFamily: 'Pretendard',
      ),
      routes: {
        '/main_screen': (context) => MainScreen(),
      },
     navigatorKey: navigatorKey,
    );
  }
}