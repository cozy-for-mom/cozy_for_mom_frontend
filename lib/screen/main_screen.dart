import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/home_fragment.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_main.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // 선택된 페이지의 인덱스 넘버 초기화

  static const TextStyle optionStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold); // 텍스트 스타일 지정이므로 해당 부분은 제거해도 된다.

  final List<Widget> _widgetOptions = <Widget>[
    const BabyMainPage(),
    const HomeFragment(),
    const CozylogMain(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/navigation_baby.png', // 사용할 이미지 파일의 경로
              width: 40,
              height: 40,
              color:
                  _selectedIndex == 0 ? primaryColor : const Color(0xffBCC0C7),
            ),
            label: '태아',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0, 5),
                )
              ]),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Image.asset(
                    'assets/images/icons/navigation_home.png', // 사용할 이미지 파일의 경로
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/navigation_community.png', // 사용할 이미지 파일의 경로
              width: 40,
              height: 40,
              color:
                  _selectedIndex == 2 ? primaryColor : const Color(0xffBCC0C7),
            ),
            label: '커뮤니티',
          ),
        ],
        currentIndex: _selectedIndex, // 지정 인덱스로 이동
        selectedItemColor: primaryColor,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
