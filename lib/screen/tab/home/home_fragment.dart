import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_page.dart';
import 'package:cozy_for_mom_frontend/screen/mom/meal/meal_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/record_icon_widget.dart';
import 'package:cozy_for_mom_frontend/service/notification/notification_domain_api_service.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_record.dart';
import 'package:cozy_for_mom_frontend/screen/mom/weight/weight_record.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
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
          userViewModel.getUserInfo(),
          notificationViewModel.getUpcomingNotification()
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
                Positioned(
                  top: 0,
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
                Positioned(
                  top: 128,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: 186,
                    height: 103,
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
                              fontSize: 16),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${pregnantInfo['nickname']} 산모님',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          "오늘도 안녕하세요",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  top: 380,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.5,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      color: contentBoxTwoColor,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 54,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MealScreen()));
                              },
                              child: const RecordIcon(
                                recordTypeName: "meal",
                                recordTypeKorName: "식단",
                                imageWidth: 26,
                                imageHeight: 37,
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
                                child: const RecordIcon(
                                  recordTypeName: "supplement",
                                  recordTypeKorName: "영양제",
                                  imageWidth: 28,
                                  imageHeight: 67,
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BloodsugarPage()));
                                },
                                child: const RecordIcon(
                                  recordTypeName: "bloodsugar",
                                  recordTypeKorName: "혈당",
                                  imageWidth: 28,
                                  imageHeight: 37,
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WeightRecord()));
                                },
                                child: const RecordIcon(
                                  recordTypeName: "weight",
                                  recordTypeKorName: "체중",
                                  imageWidth: 28,
                                  imageHeight: 37,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        InkWell(
                          onTap: () {
                            // TODO 페이지 이동 구현
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('잊지 말고 기록하세요',
                                  style: TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              const SizedBox(height: 18),
                              Container(
                                width: screenWidth - 40,
                                height: 100,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFA2A0F4),
                                    borderRadius: BorderRadius.circular(10)),
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
                                            children: [
                                              Text(
                                                  upcomingNotification[
                                                          'targetTimeAt'] ??
                                                      '13:00',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14)),
                                              const SizedBox(height: 6),
                                              Text(
                                                  upcomingNotification[
                                                          'title'] ??
                                                      '철분제 챙겨먹기',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18)),
                                            ]),
                                      ],
                                    ),
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                            "assets/images/icons/icon_supplement.png",
                                          ),
                                          height: 48,
                                          width: 30,
                                        ),
                                        Image(
                                          image: AssetImage(
                                            "assets/images/icons/icon_clock.png",
                                          ),
                                          height: 66,
                                          width: 66,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 278,
                  left: 85,
                  width: 221,
                  child: Image(
                    image: AssetImage(
                      "assets/images/baby.png",
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
