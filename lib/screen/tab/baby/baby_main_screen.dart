import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_list_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/model/baby_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    home: BabyMainScreen(),
  ));
}

class BabyMainScreen extends StatefulWidget {
  const BabyMainScreen({super.key});

  @override
  State<BabyMainScreen> createState() => _BabyMainScreenState();
}

class _BabyMainScreenState extends State<BabyMainScreen> {
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    DateTime now = DateTime.now(); // 현재 날짜
    int nowHour = int.parse(DateFormat('HH').format(now));

    // 디데이 그래프 계산
    int totalDays = 280; // 임신일 ~ 출산일 // TODO 임신일 DB에서 받아와야 함
    late int dDay, passedDay, week, day;
    late double percentage;
    late List<dynamic> babies;
    late List<String> babyNames;

    // 이미지 파일이 2개인 주차
    Set<int> weeksWithTwoImages = {4, 5, 6, 8, 9};
    // 이미지 파일이 3개인 주차
    Set<int> weeksWithThreeImages = {3};

    Random random = Random();
    int imageCount = 1; // 기본값으로 1개 설정

    return FutureBuilder(
        future: userViewModel.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantInfo = snapshot.data!;
            dDay = pregnantInfo['dDay'];
            passedDay = totalDays - dDay;
            week = passedDay ~/ 7;
            day = passedDay % 7;
            if (weeksWithTwoImages.contains(week)) {
              imageCount = 2;
            } else if (weeksWithThreeImages.contains(week)) {
              imageCount = 3;
            }
            print(
                "assets/images/baby_illust/${week}_week_${random.nextInt(imageCount) + 1}.png");
            percentage = passedDay / totalDays;
            if (percentage < 0) percentage = 1; // TODO 방어로직
            babies = pregnantInfo['recentBabyProfile'].babies;
            babyNames = babies.map((baby) => baby.babyName as String).toList();
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
            ));
          }
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Image(
                      width: 405, // TODO 화면 너비에 맞춘 width로 수정해야함
                      fit: BoxFit.cover,
                      image: AssetImage(
                          //  낮: AM8 ~ PM5 / 저녁: PM6 ~ AM7
                          nowHour >= 8 && nowHour < 18
                              ? "assets/images/babyhome_morning.png"
                              : "assets/images/babyhome_dark.png")),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyPage()));
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
                        Text(babyNames.join(''),
                            style: const TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 26)),
                        const SizedBox(height: 5),
                        Text('임신 ${week}주차 ${day}일째',
                            style: TextStyle(
                                color: //  낮: AM8 ~ PM5 / 저녁: PM6 ~ AM7
                                    nowHour >= 8 && nowHour < 18
                                        ? const Color(0xffFE8282)
                                        : const Color(0xff9D8DFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ],
                    )),
                Positioned(
                  top: 270,
                  left: 120,
                  child: Image(width: 167, height: 125, image: AssetImage(
                      // 1부터 imageCount까지
                      "assets/images/baby_illust/${week}_week_${random.nextInt(imageCount) + 1}.png")),
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
                          const Text(
                            "아기와 만나기까지",
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                          Text(' D-${dDay}', // TODO 밤/낮 따라 색상 바꿔줘야 함
                              style: TextStyle(
                                  color: //  낮: AM8 ~ PM5 / 저녁: PM6 ~ AM7
                                      nowHour >= 8 && nowHour < 18
                                          ? const Color(0xffFE8282)
                                          : const Color(0xff9D8DFF),
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
                                          const BabyGrowthReportListScreen()));
                            },
                            child: const CustomButton(
                                text: '성장 보고서',
                                imagePath: "assets/images/icons/diary.png"),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyCozylog(),
                                ),
                              );
                            },
                            child: const CustomButton(
                              text: '코지로그',
                              imagePath: "assets/images/icons/cozylog.png",
                            ),
                          ),
                        ]),
                  ),
                ),
                Positioned(
                    top: 613.52,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BabyGrowthReportListScreen()));
                      },
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
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
