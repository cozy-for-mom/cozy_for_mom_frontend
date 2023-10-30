import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy For Mom',
      home: MainScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.light(), // 필요한 테마 설정
        fontFamily: 'Pretendard',
      ),
    );
  }
}
