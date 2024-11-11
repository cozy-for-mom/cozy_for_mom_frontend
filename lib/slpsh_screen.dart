import 'package:cozy_for_mom_frontend/service/user/device_token_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeDeviceToken();
  }

  void initializeDeviceToken() async {
    DeviceTokenManager manager = DeviceTokenManager();
    Map<String, dynamic> result = await manager.initialize();
    bool permissionGranted = result['permissionGranted'] ?? false;

    if (!permissionGranted) {
      // 권한이 허용되지 않은 경우 즉시 권한 거부 처리
      handlePermissionDenied();
    }
    // if (permissionGranted) {
      // 이미 권한이 허용된 경우, 2초 지연 후 로그인 화면으로 넘어감
      Future.delayed(Duration(seconds: 2), () {
        navigateToLogin();
      });
    // } else {

    // }
  }

  void navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void handlePermissionDenied() {
    // 권한 거부 처리 로직
    print("Notification permission was denied.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
