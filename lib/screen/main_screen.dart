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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffE8ECF1))),
          color: Colors.white,
        ),
        height: 87,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppUtils.scaleSize(context, 54),
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/icons/navigation_baby.png', // 사용할 이미지 파일의 경로
                      width: AppUtils.scaleSize(context, 32),
                      height: AppUtils.scaleSize(context, 32),
                      color: selectedIndex == 0
                          ? primaryColor
                          : const Color(0xffBCC0C7),
                    ),
                    Text(
                      '태아',
                      style: TextStyle(
                          fontSize: AppUtils.scaleSize(context, 12),
                          color: selectedIndex == 0
                              ? primaryColor
                              : const Color(0xffBCC0C7),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                onTap: () => setState(() {
                  selectedIndex = 0;
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppUtils.scaleSize(context, 12)),
              child: IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff5CA6F8).withOpacity(0.5),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/icons/navigation_home.png', // 사용할 이미지 파일의 경로
                    width: AppUtils.scaleSize(context, 47),
                    height: AppUtils.scaleSize(context, 50),
                  ),
                ),
                onPressed: () => setState(() {
                  selectedIndex = 1;
                }),
              ),
            ),
            SizedBox(
              height: AppUtils.scaleSize(context, 54),
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/icons/navigation_community.png', // 사용할 이미지 파일의 경로
                      width: AppUtils.scaleSize(context, 32),
                      height: AppUtils.scaleSize(context, 32),
                      color: selectedIndex == 2
                          ? primaryColor
                          : const Color(0xffBCC0C7),
                    ),
                    Text(
                      '커뮤니티',
                      style: TextStyle(
                          fontSize: AppUtils.scaleSize(context, 12),
                          color: selectedIndex == 2
                              ? primaryColor
                              : const Color(0xffBCC0C7),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                onTap: () => setState(() {
                  selectedIndex = 2;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
