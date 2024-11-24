import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_list_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class BabyMainScreen extends StatefulWidget {
  const BabyMainScreen({super.key});

  @override
  State<BabyMainScreen> createState() => _BabyMainScreenState();
}

class _BabyMainScreenState extends State<BabyMainScreen> {
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyDataModel>(context, listen: false)
          .updateSelectedDay(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;

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
        future: userViewModel.getUserInfo(context),
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
            body: SizedBox(
              height: MediaQuery.of(context).size.height * 1.1,
              child: Stack(
                children: [
                  Positioned(
                    top:
                        MediaQuery.of(context).size.width > 600 ? -140.h : -5.h,
                    child: Image(
                        width: screenWidth,
                        fit: BoxFit.cover,
                        image: const AssetImage(
                            "assets/images/babyhome_background.png")),
                  ),
                  Positioned(
                    top: 205.h,
                    left: 0.w,
                    right: 0.w,
                    child: Image(
                      width: min(191.w, 281),
                      height: min(191.w, 281),
                      fit: BoxFit.contain,
                      image: AssetImage(
                          //  낮: AM8 ~ PM5 / 저녁: PM6 ~ AM7
                          nowHour >= 8 && nowHour < 18
                              ? "assets/images/babyhome_morning.png"
                              : "assets/images/babyhome_dark.png"),
                    ),
                  ),
                  Positioned(
                    top: 46.h,
                    left: MediaQuery.of(context).size.width > 600
                        ? screenWidth - 35.w
                        : screenWidth - 55.w,
                    child: IconButton(
                      icon: Image(
                        width: min(30.w, 40),
                        height: min(30.w, 40),
                        image: const AssetImage(
                          "assets/images/icons/mypage.png",
                        ),
                      ),
                      onPressed: () async {
                        final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyPage()));
                        if (res == true) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Positioned(
                      top: 126.h,
                      left: 0.w,
                      right: 0.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 225.w,
                            child: Text(babyNames.join(''),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: min(26.sp, 36))),
                          ),
                          SizedBox(height: min(5.w, 5)),
                          Text('임신 $week주차 $day일째',
                              style: TextStyle(
                                  color: //  낮: AM8 ~ PM5 / 저녁: PM6 ~ AM7
                                      nowHour >= 8 && nowHour < 18
                                          ? const Color(0xffFE8282)
                                          : const Color(0xff9D8DFF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: min(16.sp, 26))),
                        ],
                      )),
                  Positioned(
                    top: 254.h,
                    left: 0.w,
                    right: 0.w,
                    child: week <= 40 // 출산후(41주 이상) 태아 일러스트 없음
                        ? Image(
                            width: min(167.w, 237),
                            height: min(125.w, 195),
                            image: AssetImage(
                                // 1부터 imageCount까지
                                "assets/images/baby_illust/${week}_week_${random.nextInt(imageCount) + 1}.png"))
                        : Container(),
                  ),
                  Positioned(
                    top: 414.h,
                    left: 0.w,
                    right: 0.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "아기와 만나기까지",
                              style: TextStyle(
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: min(16.sp, 26)),
                            ),
                            Text(' D-$dDay',
                                style: TextStyle(
                                    color: //  낮: AM8 ~ PM5 / 저녁: PM6 ~ AM7
                                        nowHour >= 8 && nowHour < 18
                                            ? const Color(0xffFE8282)
                                            : const Color(0xff9D8DFF),
                                    fontWeight: FontWeight.w700,
                                    fontSize: min(16.sp, 26))),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Container(
                          width: MediaQuery.of(context).size.width > 600
                              ? screenWidth - 60.w
                              : screenWidth - 40.w,
                          height: MediaQuery.of(context).size.width > 600
                              ? 6.w
                              : 12.w,
                          decoration: BoxDecoration(
                            color: lineTwoColor, // 전체 배경색
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: percentage.clamp(0.0, 1.0),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: nowHour >= 8 && nowHour < 18
                                    ? const Color(0xffFFB4BE)
                                    : const Color(0xff9D8DFF),
                                borderRadius: BorderRadius.circular(5.w),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 478.h,
                    left: 0.w,
                    right: 0.w,
                    child: Container(
                      width: screenWidth - 40.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width > 600
                              ? 30.w
                              : 20.w),
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
                      top: 594.h,
                      left:
                          MediaQuery.of(context).size.width > 600 ? 30.w : 20.w,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BabyGrowthReportListScreen()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('성장일지를 기록해요',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: min(18.sp, 28))),
                            SizedBox(height: min(18.w, 28)),
                            Container(
                              width: MediaQuery.of(context).size.width > 600
                                  ? screenWidth - 60.w
                                  : screenWidth - 40.w,
                              height: min(100.w, 150),
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: babyNightBar,
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('오늘은 얼마나 자랐을까?',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: min(16.sp, 26))),
                                  Image(
                                      image: const AssetImage(
                                          "assets/images/icons/diary_cozylog.png"),
                                      width: min(78.44.w, 98.44),
                                      height: min(53.27.w, 73.27)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        });
  }
}
