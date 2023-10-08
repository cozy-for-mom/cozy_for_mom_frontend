import 'package:cozy_for_mom_frontend/screen/s_main.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cozy For Mom',
      home: MainScreen(),
    );
  }
}
