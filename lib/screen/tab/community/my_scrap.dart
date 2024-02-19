import 'package:cozy_for_mom_frontend/screen/tab/community/scrap_modify.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/scrap_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_record.dart';
import 'package:cozy_for_mom_frontend/common/widget/bottom_button_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_main.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class MyScrap extends StatefulWidget {
  final bool isEditMode;
  const MyScrap({super.key, this.isEditMode = false});

  @override
  State<MyScrap> createState() => _MyScrapState();
}

class _MyScrapState extends State<MyScrap> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CozylogMain()));
              },
            ),
            title: const Text('스크랩',
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CozyLogSearchPage(),
                    ),
                  );
                },
                child: const Image(
                    width: 20,
                    height: 20,
                    image: AssetImage("assets/images/icons/icon_search.png")),
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
            child: widget.isEditMode
                ? ScrapListModify(cozyLogs: cozyLogs)
                : ScrapListView(cozyLogs: cozyLogs),
          ),
        ],
      ),
      floatingActionButton: widget.isEditMode
          ? null
          : CustomFloatingButton(
              pressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CozylogRecordPage()));
              },
            ),
      bottomSheet: widget.isEditMode
          ? SizedBox(
              width: screenWidth - 40,
              child: Container(
                color: Colors.transparent,
                child: BottomSheet(
                  onClosing: () {},
                  builder: (BuildContext context) {
                    ListModifyState scrapListModifyState =
                        context.watch<ListModifyState>();
                    int selectedCount = scrapListModifyState.selectedCount;

                    bool isAnySelected = selectedCount > 0;

                    return BottomButtonWidget(
                      isActivated: isAnySelected,
                      text: '스크랩 삭제',
                      tapped: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const DeleteModal(
                              title: '스크랩이',
                              text: '등록된 스크랩을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                            );
                          },
                          barrierDismissible: false,
                        );
                      },
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }
}
