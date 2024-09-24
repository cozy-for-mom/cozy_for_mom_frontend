import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_list_screeen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_record.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                    top: 0,
                    left: 0,
                    child: Image(
                        width: screenWidth + AppUtils.scaleSize(context, 20),
                        fit: BoxFit.cover,
                        image: const AssetImage("assets/images/subtract2.png")),
                  ),
                  Positioned(
                    top: AppUtils.scaleSize(context, 47),
                    child: Container(
                        width: screenWidth,
                        padding: EdgeInsets.only(
                          top: AppUtils.scaleSize(context, 10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Image(
                                image: const AssetImage(
                                    'assets/images/icons/back_ios.png'),
                                width: AppUtils.scaleSize(context, 34),
                                height: AppUtils.scaleSize(context, 34),
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
                              width: AppUtils.scaleSize(context, 20),
                              height: AppUtils.scaleSize(context, 20),
                            ),
                            const Spacer(),
                            Text('커뮤니티',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 20))),
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
                                      width: AppUtils.scaleSize(context, 20),
                                      height: AppUtils.scaleSize(context, 20),
                                      image: const AssetImage(
                                          "assets/images/icons/icon_search.png")),
                                ),
                                IconButton(
                                  icon: Image(
                                    width: AppUtils.scaleSize(context, 24),
                                    height: AppUtils.scaleSize(context, 24),
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
                    top: AppUtils.scaleSize(context, 138),
                    left: AppUtils.scaleSize(context, 30),
                    child: pregnantInfo['imageUrl'] == null
                        ? Image.asset(
                            'assets/images/icons/momProfile.png',
                            fit: BoxFit.cover, // 이미지를 화면에 맞게 조절
                            width: AppUtils.scaleSize(context, 90),
                            height: AppUtils.scaleSize(context, 90),
                            alignment: Alignment.center,
                          )
                        : ClipOval(
                            child: Image.network(
                              pregnantInfo['imageUrl'],
                              fit: BoxFit.cover,
                              width: AppUtils.scaleSize(context, 90),
                              height: AppUtils.scaleSize(context, 90),
                            ),
                          ),
                  ),
                  Positioned(
                    top: AppUtils.scaleSize(context, 174),
                    left: AppUtils.scaleSize(context, 135),
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
                                      fontSize:
                                          AppUtils.scaleSize(context, 18))),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: AppUtils.scaleSize(context, 8),
                                    bottom: AppUtils.scaleSize(context, 4)),
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
                                        width: AppUtils.scaleSize(context, 14),
                                        height:
                                            AppUtils.scaleSize(context, 14))),
                              ),
                            ],
                          ),
                          SizedBox(height: AppUtils.scaleSize(context, 5)),
                          SizedBox(
                            width: AppUtils.scaleSize(context, 230),
                            child: Text(
                              pregnantInfo['introduce'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xff8A8A8A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppUtils.scaleSize(context, 14)),
                            ),
                          ),
                        ]),
                  ),
                  Positioned(
                    top: AppUtils.scaleSize(context, 255),
                    left: AppUtils.scaleSize(context, 10),
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      margin: EdgeInsets.all(AppUtils.scaleSize(context, 10)),
                      color: contentBoxTwoColor,
                      child: SizedBox(
                        width: screenWidth - AppUtils.scaleSize(context, 40),
                        height: AppUtils.scaleSize(context, 102),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTextButton(
                                text: '내 코지로그',
                                textColor: mainTextColor,
                                textWeight: FontWeight.w600,
                                imagePath: 'assets/images/icons/cozylog.png',
                                imageWidth: 27.3,
                                imageHeight: 24.34,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyCozylog()));
                                }),
                            Container(
                              width: 1,
                              height: AppUtils.scaleSize(context, 42),
                              color: const Color(0xffE8E8ED),
                            ),
                            CustomTextButton(
                                text: '스크랩 내역',
                                textColor: mainTextColor,
                                textWeight: FontWeight.w600,
                                imagePath: 'assets/images/icons/scrap.png',
                                imageWidth: 18.4,
                                imageHeight: 24,
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
                    top: AppUtils.scaleSize(context, 393.4),
                    left: AppUtils.scaleSize(context, 21),
                    child: SizedBox(
                      width: screenWidth - AppUtils.scaleSize(context, 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '최신 코지로그',
                            style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: AppUtils.scaleSize(context, 18),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CozyLogListScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffA9ABB7),
                                  borderRadius: BorderRadius.circular(
                                    21,
                                  )),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppUtils.scaleSize(context, 8),
                                  vertical: AppUtils.scaleSize(context, 2),
                                ),
                                child: Text(
                                  "더보기",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppUtils.scaleSize(context, 12),
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
                    top: AppUtils.scaleSize(context, 434),
                    left: AppUtils.scaleSize(context, 20),
                    child: Container(
                      width: screenWidth - AppUtils.scaleSize(context, 40),
                      height: screenHeight * 0.375,
                      padding: EdgeInsets.only(
                        left: AppUtils.scaleSize(context, 22),
                        right: AppUtils.scaleSize(context, 22),
                      ),
                      decoration: BoxDecoration(
                        color: contentBoxTwoColor,
                        borderRadius: BorderRadius.circular(20),
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
                                          fontSize: AppUtils.scaleSize(
                                              context, 16))));
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
                                    const SizedBox(height: 24),
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
