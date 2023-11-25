import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/model/baby_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/custom_button.dart';
import 'package:cozy_for_mom_frontend/screen/baby/grow_report_register.dart';

void main() {
  runApp(const MaterialApp(
    home: BabyMainPage(),
  ));
}

class BabyMainPage extends StatefulWidget {
  const BabyMainPage({super.key});

  @override
  State<BabyMainPage> createState() => _BabyMainPageState();
}

class _BabyMainPageState extends State<BabyMainPage> {
  final baby = BabyProfile(
      babyId: 1,
      image: "assets/images/babyProfileTest.png",
      name: "미룽이",
      isProfileSelected: true);

  @override
  Widget build(BuildContext context) {
    final DateTime dueDate = DateTime(2024, 2, 11); // TODO 출산 예정일 DB에서 받아와야 함
    DateTime now = DateTime.now(); // 현재 날짜
    Duration difference = dueDate.difference(now);

    // 디데이 그래프 계산
    double totalDays = 280.0; // 임신일 ~ 출산일 // TODO 임신일 DB에서 받아와야 함
    double daysPassed = totalDays - difference.inDays.toDouble(); // 현재 날짜 ~ 출산일
    double percentage = daysPassed / totalDays;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            child: Image(
                width: 405, // TODO 화면 너비에 맞춘 width로 수정해야함
                fit: BoxFit.cover,
                image: AssetImage(
                    "assets/images/babyhome_dark.png")), // TODO 밤/낮 따라 이미지경로 바꿔줘야 함
          ),
          Positioned(
            top: 66,
            left: 340,
            child: IconButton(
              icon: const Image(
                width: 30,
                height: 30,
                image: AssetImage(
                  "assets/images/icons/mypage.png",
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyPage()));
              },
            ),
          ),
          Positioned(
              top: 145,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(baby.name,
                      style: const TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 26)),
                  const SizedBox(height: 5),
                  const Text('임신 12주차 1일째',
                      style: TextStyle(
                          color: Color(0xff9D8DFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ],
              )),
          const Positioned(
            top: 278,
            left: 106,
            child: Image(
                width: 187,
                height: 145,
                image: AssetImage("assets/images/baby2_1.png")),
          ),
          const Positioned(
            top: 291,
            left: 120,
            child: Image(
                width: 167,
                height: 125,
                image: AssetImage("assets/images/baby2_2.png")),
          ),
          const Positioned(
            top: 355.52,
            left: 114,
            child: Image(
                width: 66,
                height: 34.67,
                image: AssetImage("assets/images/umbilical_cord.png")),
          ),
          Positioned(
            top: 433,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${baby.name}와 만나는 날",
                      style: const TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    Text(' D-${difference.inDays}', // TODO 밤/낮 따라 색상 바꿔줘야 함
                        style: const TextStyle(
                            color: babyNightBar,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 313,
                  height: 12,
                  decoration: BoxDecoration(
                    color: lineTwoColor, // 전체 배경색
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: percentage,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: babyNightBar, // TODO 밤/낮 따라 색상 바꿔줘야 함
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 501.52,
            left: 20,
            child: SizedBox(
              width: 350,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GrowReportRegister()));
                      },
                      child: const CustomButton(
                          text: '성장 보고서',
                          imagePath: "assets/images/icons/diary.png"),
                    ),
                    InkWell(
                      onTap: () {
                        print('코지로그 페이지 이동'); // TODO 코지로그 페이지 연동
                      },
                      child: const CustomButton(
                          text: '코지로그',
                          imagePath: "assets/images/icons/cozylog.png"),
                    ),
                  ]),
            ),
          ),
          Positioned(
              top: 613.52,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('성장일지를 기록해요',
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  const SizedBox(height: 18),
                  Container(
                    width: 350,
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: babyNightBar,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('오늘은 얼마나 자랐을까?',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        Image(
                            image: AssetImage(
                                "assets/images/icons/diary_cozylog.png"),
                            width: 78.44,
                            height: 53.27),
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
