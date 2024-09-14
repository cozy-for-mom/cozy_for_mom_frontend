import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_page.dart';
import 'package:cozy_for_mom_frontend/screen/mom/meal/meal_screen.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/record_icon_widget.dart';
import 'package:cozy_for_mom_frontend/service/notification/notification_domain_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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
                  top: AppUtils.scaleSize(context, 128),
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: AppUtils.scaleSize(context, 186),
                    height: AppUtils.scaleSize(context, 103),
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
                              fontSize: AppUtils.scaleSize(context, 16)),
                        ),
                        SizedBox(height: AppUtils.scaleSize(context, 3)),
                        Text(
                          '${pregnantInfo['nickname']} 산모님',
                          style: TextStyle(
                            fontSize: AppUtils.scaleSize(context, 26),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "오늘도 안녕하세요",
                          style: TextStyle(
                            fontSize: AppUtils.scaleSize(context, 26),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppUtils.scaleSize(context, 46),
                  left: screenWidth - AppUtils.scaleSize(context, 55),
                  child: IconButton(
                    icon: Image(
                      width: AppUtils.scaleSize(context, 30),
                      height: AppUtils.scaleSize(context, 30),
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
                Positioned(
                  top: AppUtils.scaleSize(context, 380),
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
                        SizedBox(
                          height: AppUtils.scaleSize(context, 54),
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
                        SizedBox(
                          height: AppUtils.scaleSize(context, 40),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('잊지 말고 기록하세요',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppUtils.scaleSize(context, 18))),
                            SizedBox(height: AppUtils.scaleSize(context, 18)),
                            InkWell(
                              onTap: () async {
                                final type = upcomingNotification['type'] ==
                                        CardType.bloodsugar.name
                                    ? CardType.bloodsugar
                                    : CardType.supplement;

                                final shouldRefresh = await Navigator.push(
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
                                width: screenWidth -
                                    AppUtils.scaleSize(context, 40),
                                height: AppUtils.scaleSize(context, 100),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppUtils.scaleSize(context, 30)),
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
                                            children: upcomingNotification[
                                                        'targetTimeAt'] ==
                                                    ''
                                                ? [
                                                    Text('영양제와 혈당 알림을',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    14))),
                                                    Text('등록해보세요!',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    14)))
                                                  ]
                                                : [
                                                    Text(
                                                        upcomingNotification[
                                                            'targetTimeAt'],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    14))),
                                                    SizedBox(
                                                        height:
                                                            AppUtils.scaleSize(
                                                                context, 6)),
                                                    Text(
                                                        upcomingNotification[
                                                            'title'],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    18))),
                                                  ]),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                            upcomingNotification['type'] ==
                                                    CardType.bloodsugar.name
                                                ? "assets/images/icons/icon_bloodsugar.png"
                                                : "assets/images/icons/icon_supplement.png",
                                          ),
                                          height:
                                              AppUtils.scaleSize(context, 48),
                                          width:
                                              AppUtils.scaleSize(context, 30),
                                        ),
                                        Image(
                                          image: const AssetImage(
                                            "assets/images/icons/icon_clock.png",
                                          ),
                                          height:
                                              AppUtils.scaleSize(context, 66),
                                          width:
                                              AppUtils.scaleSize(context, 66),
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
                  top: AppUtils.scaleSize(context, 278),
                  left: AppUtils.scaleSize(context, 85),
                  width: AppUtils.scaleSize(context, 221),
                  child: const Image(
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
