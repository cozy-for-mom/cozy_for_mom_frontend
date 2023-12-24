import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/model/cozylog_model.dart';

class CozylogListModify extends StatefulWidget {
  const CozylogListModify({super.key});

  @override
  State<CozylogListModify> createState() => _CozylogListModifyState();
}

class _CozylogListModifyState extends State<CozylogListModify> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
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
      CozyLog(
        id: 4,
        commentCount: 16,
        scrapCount: 2,
        imageCount: 0,
        title: "산모교실? 같은데 가보신분~",
        summary:
            "인스타보면 산모교실 참석하면 바운서도 주고 하던데유ㅎㅎㅎ 거기 가면 뭐하는건가요? 어떤 도움을 받을 수 있는지 궁금해서 코지로그 글 올려봅니당",
        date: "2023-10-28",
      ),
      // 추가적인 CozyLog 인스턴스들...
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('내 코지로그',
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            actions: [
              InkWell(
                onTap: () {
                  print('검색 페이지 이동'); // TODO 검색창 이동 구현
                },
                child: const Image(
                    width: 20,
                    height: 20,
                    image: AssetImage("assets/images/icons/search_black.png")),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MyPage()));
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                width: screenWidth - 40,
                height: 53,
                decoration: BoxDecoration(
                    color: const Color(0xffF0F0F5),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Image(
                            image:
                                AssetImage('assets/images/icons/cozylog.png'),
                            width: 25.02,
                            height: 23.32),
                        const SizedBox(width: 8),
                        Text(
                          '${cozyLogs.length}개의 코지로그',
                          style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ]),
                      const Text(
                        '편집',
                        style: TextStyle(
                            color: offButtonTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ]),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 22),
          ),
          SliverToBoxAdapter(
              child: cozyLogs.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: screenWidth - 40,
                        height: boxHeight * cozyLogs.length + 20,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: contentBoxTwoColor),
                        child: Column(
                          children: cozyLogs
                              .map((cozylog) =>
                                  CozylogViewWidget(cozylog: cozylog))
                              .toList(),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 144,
                      height: screenHeight * (0.6),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                                image: AssetImage(
                                    'assets/images/icons/cozylog_off.png'),
                                width: 45.31,
                                height: 40.77),
                            SizedBox(height: 12),
                            Text('코지로그를 작성해 보세요!',
                                style: TextStyle(
                                    color: Color(0xff9397A4),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ]),
                    )),
        ],
      ),
    );
  }
}
