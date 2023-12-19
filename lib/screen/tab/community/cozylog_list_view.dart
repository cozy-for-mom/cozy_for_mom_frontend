import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';

class CozylogListView extends StatefulWidget {
  const CozylogListView({super.key});

  @override
  State<CozylogListView> createState() => _CozylogListViewState();
}

class _CozylogListViewState extends State<CozylogListView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
          ],
        ),
      ),
    );
  }
}
