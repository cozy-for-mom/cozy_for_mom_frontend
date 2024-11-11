import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_list_screeen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_record.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_text_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/profile_modify.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CozylogMain extends StatefulWidget {
  const CozylogMain({super.key});

  @override
  State<CozylogMain> createState() => _CozylogMainState();
}

class _CozylogMainState extends State<CozylogMain> {
  late Future<List<CozyLogForList>?> cozyLogs;
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;

  @override
  void initState() {
    super.initState();
    cozyLogs = CozyLogApiService().getCozyLogs(
      context,
      null,
      10,
    );
  }

  void reloadCozyLogs() {
    cozyLogs = CozyLogApiService().getCozyLogs(
      context,
      null,
      10,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    return FutureBuilder(
        future: userViewModel.getUserInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantInfo = snapshot.data!;
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
            ));
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: backgroundColor,
            body: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Stack(
                children: [
                  Positioned(
                    top: isTablet ? -100.h : 0.h,
                    left: 0.w,
                    child: Image(
                        width: screenWidth + paddingValue,
                        fit: BoxFit.cover,
                        image: const AssetImage("assets/images/subtract2.png")),
                  ),
                  Positioned(
                    top: isTablet ? 17.h : 34.h,
                    child: Container(
                        width: screenWidth,
                        padding: EdgeInsets.only(top: 10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Image(
                                image: const AssetImage(
                                    'assets/images/icons/back_ios.png'),
                                width: min(34.w, 44),
                                height: min(34.w, 44),
                                color: mainTextColor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen())); // TODO depth가 복잡해져서 커뮤니티에서는 뒤로가기하면 메인페이지로 가도록 픽스
                              },
                            ),
                            SizedBox(
                              width: min(20.w, 30),
                              height: min(20.w, 30),
                            ),
                            const Spacer(),
                            Text('커뮤니티',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(18.sp, 28))),
                            const Spacer(),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CozyLogSearchPage(),
                                      ),
                                    );
                                  },
                                  child: Image(
                                      width: min(20.w, 30),
                                      height: min(20.w, 30),
                                      image: const AssetImage(
                                          "assets/images/icons/icon_search.png")),
                                ),
                                IconButton(
                                  icon: Image(
                                    width: min(24.w, 34),
                                    height: min(24.w, 34),
                                    image: const AssetImage(
                                      "assets/images/icons/mypage.png",
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyPage()));
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    top: isTablet? 104.h : 134.h,
                    left: isTablet? 32.w : 28.w,
                    child: pregnantInfo['imageUrl'] == null
                        ? Image.asset(
                            'assets/images/icons/momProfile.png',
                            fit: BoxFit.cover, // 이미지를 화면에 맞게 조절
                            width: min(90.w, 180),
                            height: min(90.w, 180),
                            alignment: Alignment.center,
                          )
                        : ClipOval(
                            child: Image.network(
                              pregnantInfo['imageUrl'],
                              fit: BoxFit.cover,
                              width: min(90.w, 180),
                              height: min(90.w, 180),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 167.h,
                    left: 135.w,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(pregnantInfo['nickname'],
                                  style: TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: min(18.sp, 28))),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 8.w, bottom: 4.w),
                                child: InkWell(
                                    onTap: () async {
                                      final res = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MomProfileModify()));
                                      if (res == true) {
                                        setState(() {});
                                      }
                                    },
                                    child: Image(
                                        image: const AssetImage(
                                            'assets/images/icons/pen.png'),
                                        width: min(14.w, 24),
                                        height: min(14.w, 24))),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.w),
                          SizedBox(
                            width: 230.w,
                            child: Text(
                              pregnantInfo['introduce'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: const Color(0xff8A8A8A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: min(14.sp, 24)),
                            ),
                          ),
                        ]),
                  ),
                  Positioned(
                    top: 255.h,
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.w)),
                      margin: EdgeInsets.symmetric(
                          horizontal: paddingValue, vertical: 10.w),
                      color: contentBoxTwoColor,
                      child: SizedBox(
                        width: screenWidth - 2 * paddingValue,
                        height: min(102.w, 152),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTextButton(
                                text: '내 코지로그',
                                textColor: mainTextColor,
                                textWeight: FontWeight.w600,
                                imagePath: 'assets/images/icons/cozylog.png',
                                imageWidth: min(27.3.w, 47.3),
                                imageHeight: min(24.34.w, 44.34),
                                onPressed: () async {
                                  final res = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyCozylog()));
                                  if (res == true) {
                                    setState(() {
                                      reloadCozyLogs();
                                    });
                                  }
                                }),
                            Container(
                              width: 1.w,
                              height: 42.w,
                              color: const Color(0xffE8E8ED),
                            ),
                            CustomTextButton(
                                text: '스크랩 내역',
                                textColor: mainTextColor,
                                textWeight: FontWeight.w600,
                                imagePath: 'assets/images/icons/scrap.png',
                                imageWidth: min(18.4.w, 38.4),
                                imageHeight: min(24.w, 44),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyScrap()));
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 393.4.h,
                    left: paddingValue,
                    child: SizedBox(
                      width: screenWidth - 2 * paddingValue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '최신 코지로그',
                            style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: min(18.sp, 28),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CozyLogListScreen(),
                                ),
                              );
                              if (res == true) {
                                setState(() {
                                  reloadCozyLogs();
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffA9ABB7),
                                  borderRadius: BorderRadius.circular(
                                    21.w,
                                  )),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.w,
                                ),
                                child: Text(
                                  "더보기",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: min(12.sp, 22),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 434.h,
                    left: paddingValue,
                    child: Container(
                      width: screenWidth - 2 * paddingValue,
                      height: screenHeight * 0.375,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: contentBoxTwoColor,
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      child: FutureBuilder(
                        future: cozyLogs,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == null) {
                              return Center(
                                  child: Text("최근 작성된 글이 없습니다.",
                                      style: TextStyle(
                                          color: const Color(0xff9397A4),
                                          fontWeight: FontWeight.w500,
                                          fontSize: min(16.sp, 26))));
                            } else {
                              return SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    ...snapshot.data!
                                        .map((cozylog) => CozylogViewWidget(
                                              isLast: cozylog ==
                                                  snapshot.data!
                                                      .last, // 마지막 아이템인지 판단
                                              cozylog: cozylog,
                                              isMyCozyLog: false,
                                              onUpdate: () {
                                                setState(() {
                                                  cozyLogs = CozyLogApiService()
                                                      .getCozyLogs(
                                                    context,
                                                    null,
                                                    10,
                                                  );
                                                });
                                              },
                                            ))
                                        .toList(),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                              backgroundColor: primaryColor,
                              color: Colors.white,
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: CustomFloatingButton(
              pressed: () async {
                final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CozylogRecordPage()));

                if (res == true) {
                  setState(() {
                    cozyLogs = CozyLogApiService().getCozyLogs(
                      context,
                      null,
                      10,
                    );
                  });
                }
              },
            ),
          );
        });
  }
}
