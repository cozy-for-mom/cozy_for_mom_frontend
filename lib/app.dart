import 'package:cozy_for_mom_frontend/slpsh_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '코지포맘',
      home: const SplashScreen(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(), // 필요한 테마 설정
        fontFamily: 'Pretendard',
      ),
    );
  }
}
