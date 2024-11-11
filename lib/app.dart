import 'package:cozy_for_mom_frontend/screen/login/login_screen.dart';
import 'package:cozy_for_mom_frontend/slpsh_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 845),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: '코지포맘',
            home: const SplashScreen(),
            theme: ThemeData(
              colorScheme: const ColorScheme.light(), // 필요한 테마 설정
              fontFamily: 'Pretendard',
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: Color(0xff5CA6F8),
              ),
            ),
            routes: {
              '/login': (context) => const LoginScreen(),
            },
          );
        });
  }
}
