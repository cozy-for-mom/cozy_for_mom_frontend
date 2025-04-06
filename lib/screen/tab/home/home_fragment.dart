import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_page.dart';
import 'package:cozy_for_mom_frontend/screen/mom/meal/meal_screen.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/record_icon_widget.dart';
import 'package:cozy_for_mom_frontend/service/notification/notification_domain_api_service.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_record.dart';
import 'package:cozy_for_mom_frontend/screen/mom/weight/weight_record.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({
    super.key,
  });
  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;
  late Map<String, dynamic> upcomingNotification;
  late NotificationApiService notificationViewModel;

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
    notificationViewModel =
        Provider.of<NotificationApiService>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    int nowHour = int.parse(DateFormat('HH').format(now));
    int nowMonth = int.parse(DateFormat('M').format(now));
    int nowDay = int.parse(DateFormat('d').format(now));
    String nowWeekDay = DateFormat.EEEE('ko').format(now);

    return FutureBuilder(
        future: Future.wait([
          userViewModel.getUserInfo(context),
          notificationViewModel.getUpcomingNotification(context)
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
            ));
          }

          if (snapshot.hasData) {
            pregnantInfo = snapshot.data![0];
            upcomingNotification = snapshot.data![1];
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return Scaffold(
            body: Stack(
              children: [
                // =========== 1) 고정 배경 이미지  ===========
                Positioned(
                  top: 0.h,
                  child: Image(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    image: AssetImage(
                        // 아침: AM8 ~AM11 / 점심(저녁): PM12 ~ PM6 / 밤: PM6 ~ AM7
                        nowHour >= 8 && nowHour < 12
                            ? "assets/images/home_morning.png"
                            : nowHour >= 12 && nowHour < 19
                                ? "assets/images/home_afternoon.png"
                                : "assets/images/home_evening.png"),
                  ),
                ),

                // =========== 2) 스크롤될 메인 콘텐츠  ===========
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(children: [
                      Positioned(
                        top: 128.h,
                        left: 0.w,
                        right: 0.w,
                        child: SizedBox(
                          width: 186.w,
                          height: 103.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$nowMonth월 $nowDay일 $nowWeekDay',
                                style: TextStyle(
                                    color: nowHour >= 8 && nowHour < 12
                                        ? morningTextColor
                                        : nowHour >= 12 && nowHour < 19
                                            ? afternoonTextColor
                                            : nightTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(16.sp, 26)),
                              ),
                              SizedBox(height: 3.w),
                              Text(
                                '${pregnantInfo['nickname']} 산모님',
                                style: TextStyle(
                                  fontSize: min(26.sp, 36),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "오늘도 안녕하세요",
                                style: TextStyle(
                                  fontSize: min(26.sp, 36),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 380.h,
                        left: 0.w,
                        right: 0.w,
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.w),
                              topRight: Radius.circular(40.w),
                            ),
                            color: contentBoxTwoColor,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: min(54.w, 64),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width > 600
                                            ? 30.w
                                            : 20.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MealScreen()));
                                      },
                                      child: RecordIcon(
                                        recordTypeName: "meal",
                                        recordTypeKorName: "식단",
                                        imageWidth: min(26.w, 46),
                                        imageHeight: min(37.w, 57),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SupplementRecord()));
                                        },
                                        child: RecordIcon(
                                          recordTypeName: "supplement",
                                          recordTypeKorName: "영양제",
                                          imageWidth: min(28.w, 48),
                                          imageHeight: min(67.w, 87),
                                        )),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BloodsugarPage()));
                                        },
                                        child: RecordIcon(
                                          recordTypeName: "bloodsugar",
                                          recordTypeKorName: "혈당",
                                          imageWidth: min(28.w, 48),
                                          imageHeight: min(37.w, 57),
                                        )),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WeightRecord()));
                                        },
                                        child: RecordIcon(
                                          recordTypeName: "weight",
                                          recordTypeKorName: "체중",
                                          imageWidth: min(28.w, 48),
                                          imageHeight: min(37.w, 57),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: min(40.w, 50),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('잊지 말고 기록하세요',
                                      style: TextStyle(
                                          color: mainTextColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: min(18.sp, 28))),
                                  SizedBox(height: min(18.w, 28)),
                                  InkWell(
                                    onTap: () async {
                                      final type =
                                          upcomingNotification['type'] ==
                                                  CardType.bloodsugar.name
                                              ? CardType.bloodsugar
                                              : CardType.supplement;

                                      final shouldRefresh =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AlarmSettingPage(type: type)),
                                      );

                                      if (mounted && shouldRefresh == true) {
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? screenWidth - 60.w
                                          : screenWidth - 40.w,
                                      height: min(100.w, 150),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFA2A0F4),
                                          borderRadius:
                                              BorderRadius.circular(10.w)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: upcomingNotification[
                                                              'targetTimeAt'] ==
                                                          ''
                                                      ? [
                                                          Text('영양제와 혈당 알림을',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: min(
                                                                      14.sp,
                                                                      24))),
                                                          Text('등록해보세요!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: min(
                                                                      14.sp,
                                                                      24)))
                                                        ]
                                                      : [
                                                          Text(
                                                              upcomingNotification[
                                                                  'targetTimeAt'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: min(
                                                                      14.sp,
                                                                      24))),
                                                          SizedBox(height: 6.w),
                                                          SizedBox(
                                                            width:
                                                                min(180.w, 400),
                                                            child: Text(upcomingNotification['title'],
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize: min(
                                                                        18.sp,
                                                                        28))),
                                                          ),
                                                        ]),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  upcomingNotification[
                                                              'type'] ==
                                                          CardType
                                                              .bloodsugar.name
                                                      ? "assets/images/icons/icon_bloodsugar.png"
                                                      : "assets/images/icons/icon_supplement.png",
                                                ),
                                                height: min(48.w, 68),
                                                width: min(30.w, 50),
                                              ),
                                              Image(
                                                image: const AssetImage(
                                                  "assets/images/icons/icon_clock.png",
                                                ),
                                                height: min(66.w, 86),
                                                width: min(66.w, 86),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 278.h,
                        left: 0.w,
                        right: 0.w,
                        child: Center(
                          child: SizedBox(
                            width: min(221.w, 321),
                            child: const Image(
                              image: AssetImage("assets/images/baby.png"),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                // =========== 3) 고정 아이콘(마이페이지) ===========
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyPage()));
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
