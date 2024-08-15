import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/home_fragment.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_main.dart';

class MainScreen extends StatefulWidget {
  final int selectedIndex;
  const MainScreen({super.key, this.selectedIndex = 1});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 1;

  final List<Widget> _widgetOptions = <Widget>[
    const BabyMainScreen(),
    const HomeFragment(),
    const CozylogMain(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex; // 선택된 페이지의 인덱스 넘버 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/navigation_baby.png', // 사용할 이미지 파일의 경로
              width: AppUtils.scaleSize(context, 40),
              height: AppUtils.scaleSize(context, 40),
              color:
                  selectedIndex == 0 ? primaryColor : const Color(0xffBCC0C7),
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
                  SizedBox(
                    height: AppUtils.scaleSize(context, 8),
                  ),
                  Image.asset(
                    'assets/images/icons/navigation_home.png', // 사용할 이미지 파일의 경로
                    width: AppUtils.scaleSize(context, 50),
                    height: AppUtils.scaleSize(context, 50),
                  ),
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/navigation_community.png', // 사용할 이미지 파일의 경로
              width: AppUtils.scaleSize(context, 40),
              height: AppUtils.scaleSize(context, 40),
              color:
                  selectedIndex == 2 ? primaryColor : const Color(0xffBCC0C7),
            ),
            label: '커뮤니티',
          ),
        ],
        currentIndex: selectedIndex, // 지정 인덱스로 이동
        selectedItemColor: primaryColor,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
