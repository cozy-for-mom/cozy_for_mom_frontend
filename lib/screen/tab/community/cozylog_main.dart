import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_text_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/model/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/profile_modify.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';

class CozylogMain extends StatelessWidget {
  const CozylogMain({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final user = User(1, "쥬쥬", "안소현", "shsh@shsh.com", DateTime(1999, 3, 3));
    final cozyLogs = [
      CozyLog(
        id: 1,
        commentCount: 3,
        scrapCount: 10,
        imageCount: 1,
        title: "산부인과 다녀왔어요ㅋㅋ",
        summary: "오늘 산부인과 다녀왔어요^_^ 오는길에 딸기가 보이길래 한 팩 사왔네요.",
        date: "2023-10-28",
        imageUrl: "assets/images/test_image.png",
      ),
      CozyLog(
        id: 2,
        commentCount: 4,
        scrapCount: 10,
        imageCount: 2,
        title: "오늘 병원에 다녀왔는데 새로운 정보를 알게 되어서 공유합니다~",
        summary: "의외로 임신중 날계란을 피해야한다고 하더라고요 몰랐던 사실이라 공유합니다.",
        date: "2023-10-29",
        imageUrl: "assets/images/test_image2.png",
      ),
      CozyLog(
        id: 3,
        commentCount: 4,
        scrapCount: 8,
        imageCount: 0,
        title: "영양제 뭐 드시나요?",
        summary: "임신 중에 유독 과일이 먹고싶더라고요 근데 요즘 과일 값이 금값이라 내키는대로 사먹을 수가 없네요ㅠㅠ",
        date: "2023-10-29",
      ),
      // 추가적인 CozyLog 인스턴스들...
    ];

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
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 110), // TODO 화면 너비에 맞춘 width로 수정해야함
                      const Text('커뮤니티',
                          style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      const SizedBox(width: 90), // TODO 화면 너비에 맞춘 width로 수정해야함
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              print('검색 페이지 이동'); // TODO 검색창 이동 구현
                            },
                            child: const Image(
                                width: 20,
                                height: 20,
                                image: AssetImage(
                                    "assets/images/icons/search_black.png")),
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
                                      builder: (context) => const MyPage()));
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
                        Text(user.nickname,
                            style: const TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MomProfileModify()));
                              },
                              child: const Image(
                                  image:
                                      AssetImage('assets/images/icons/pen.png'),
                                  width: 14,
                                  height: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '안녕하세요 반가워요!',
                      style: TextStyle(
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
                                    builder: (context) => const MyCozylog()));
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
                                    builder: (context) => const MyScrap()));
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
                      fontSize: 18),
                )),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: cozyLogs
                        .map((cozylog) => CozylogViewWidget(cozylog: cozylog))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          CustomFloatingButton(), // TODO 버튼 클릭 시 코지로그 등록 페이지로 이동
    );
  }
}
