import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_record.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/home_fragment.dart';
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
import 'package:provider/provider.dart';

class CozylogMain extends StatefulWidget {
  const CozylogMain({super.key});

  @override
  State<CozylogMain> createState() => _CozylogMainState();
}

class _CozylogMainState extends State<CozylogMain> {
  late Future<List<CozyLogForList>> cozyLogs;
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;

  @override
  void initState() {
    super.initState();
    cozyLogs = CozyLogApiService().getCozyLogs(
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
        // TODO 캘린더 연동 (선택한 날짜로 API 요청하도록 수정)
        future: userViewModel.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantInfo = snapshot.data!;
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent, // 로딩화면(circle)
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
                        width: screenWidth + 20,
                        fit: BoxFit.cover,
                        image: const AssetImage("assets/images/subtract2.png")),
                  ),
                  Positioned(
                    top: 47,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen())); // TODO depth가 복잡해져서 커뮤니티에서는 뒤로가기하면 메인페이지로 가도록 픽스
                              },
                            ),
                            const SizedBox(
                                width: 110), // TODO 화면 너비에 맞춘 width로 수정해야함
                            const Text('커뮤니티',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)),
                            const SizedBox(
                                width: 90), // TODO 화면 너비에 맞춘 width로 수정해야함
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
                                  child: const Image(
                                      width: 20,
                                      height: 20,
                                      image: AssetImage(
                                          "assets/images/icons/icon_search.png")),
                                ),
                                IconButton(
                                  icon: const Image(
                                    width: 24,
                                    height: 24,
                                    image: AssetImage(
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
                  const Positioned(
                      top: 138,
                      left: 30,
                      child: Image(
                        image: AssetImage('assets/images/icons/momProfile.png'),
                        width: 90,
                        height: 90,
                      )),
                  Positioned(
                    top: 174,
                    left: 135,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(pregnantInfo['nickname'],
                                  style: const TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 4),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MomProfileModify()));
                                    },
                                    child: const Image(
                                        image: AssetImage(
                                            'assets/images/icons/pen.png'),
                                        width: 14,
                                        height: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            pregnantInfo['introduce'],
                            style: const TextStyle(
                                color: Color(0xff8A8A8A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ]),
                  ),
                  Positioned(
                    top: 255,
                    left: 10,
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      margin: const EdgeInsets.all(10),
                      color: contentBoxTwoColor,
                      child: SizedBox(
                        width: screenWidth - 40,
                        height: 102,
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
                              height: 42,
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
                  const Positioned(
                    top: 393.4,
                    left: 21,
                    child: Text(
                      '최신 코지로그',
                      style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 427,
                    left: 20,
                    child: Container(
                      width: screenWidth - 40,
                      height: 540,
                      padding: const EdgeInsets.only(
                        top: 6,
                        bottom: 30,
                        left: 22,
                        right: 22,
                      ),
                      decoration: BoxDecoration(
                        color: contentBoxTwoColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FutureBuilder(
                        future: cozyLogs,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Column(
                                children: snapshot.data!
                                    .map((cozylog) => CozylogViewWidget(
                                          cozylog: cozylog,
                                          isMyCozyLog: false,
                                        ))
                                    .toList(),
                              ),
                            );
                          } else {
                            return const Text("최근 작성된 글이 없습니다.");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: CustomFloatingButton(
              pressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CozylogRecordPage()));
              },
            ),
          );
        });
  }
}
