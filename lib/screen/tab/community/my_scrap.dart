import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/scrap_modify.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_record.dart';
import 'package:cozy_for_mom_frontend/common/widget/bottom_button_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class MyScrap extends StatefulWidget {
  final bool isEditMode;
  const MyScrap({super.key, this.isEditMode = false});

  @override
  State<MyScrap> createState() => _MyScrapState();
}

class _MyScrapState extends State<MyScrap> {
  late Future<ScrapCozyLogListWrapper> cozyLogWrapper;
  bool isAllSelected = false;

  PagingController<int, CozyLogForList> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final cozyLogWrapper =
          await CozyLogApiService().getScrapCozyLogs(pageKey, 10);
      final cozyLogs = cozyLogWrapper.cozyLogs;
      final isLastPage = cozyLogs.length < 10;

      if (isLastPage) {
        pagingController.appendLastPage(cozyLogs);
      } else {
        final nextPageKey = pageKey + cozyLogs.length; // 데이터 길이를 이용한 페이지 키 증가
        pagingController.appendPage(cozyLogs, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListModifyState>(context, listen: false).clearSelection();
    });
    cozyLogWrapper = CozyLogApiService().getScrapCozyLogs(null, 10);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0.0,
        title: const Text(
          '스크랩',
          style: TextStyle(
              color: mainTextColor, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(selectedIndex: 2),
              ),
            );
          },
        ),
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
      body: FutureBuilder(
        future: cozyLogWrapper,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final totalHeight = boxHeight * snapshot.data!.cozyLogs.length + 20;
            return widget.isEditMode
                ? ScrapListModify(
                    // TODO 왜 바로 ScrapListModify 안가고 MyScrap를 거쳐가는거지? 데이터 사용하려고?!
                    cozyLogs: snapshot.data!.cozyLogs,
                    totalCount: snapshot.data!.totalCount,
                  )
                : Column(
                    children: [
                      Padding(
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
                                      image: AssetImage(
                                          'assets/images/icons/scrap.png'),
                                      width: 18.4,
                                      height: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${snapshot.data!.totalCount}개의 스크랩',
                                    style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ]),
                                InkWell(
                                  onTap: () {
                                    snapshot.data!.cozyLogs.isNotEmpty
                                        ? setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyScrap(
                                                  isEditMode: true,
                                                ),
                                              ),
                                            );
                                          })
                                        : setState(() {});
                                  },
                                  child: const Text(
                                    '편집',
                                    style: TextStyle(
                                        color: offButtonTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 22),
                      snapshot.data!.cozyLogs.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Container(
                                width: screenWidth - 40,
                                // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                                height: screenHeight * (0.75),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: contentBoxTwoColor,
                                ),
                                child: PagedListView<int, CozyLogForList>(
                                  padding: EdgeInsets.only(
                                      bottom: screenHeight * 0.35),
                                  pagingController: pagingController,
                                  builderDelegate:
                                      PagedChildBuilderDelegate<CozyLogForList>(
                                    itemBuilder: (context, item, index) =>
                                        CozylogViewWidget(
                                      cozylog: item,
                                      isEditMode: false,
                                      isMyCozyLog: true,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 150,
                              height: screenHeight * (0.6),
                              child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                        image: AssetImage(
                                            'assets/images/icons/scrap_off.png'),
                                        width: 34.54,
                                        height: 45.05),
                                    SizedBox(height: 12),
                                    Text('코지로그를 스크랩 해보세요!',
                                        style: TextStyle(
                                            color: Color(0xff9397A4),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ]),
                            ),
                    ],
                  );
          } else {
            return SizedBox(
              height: screenHeight * (3 / 4),
              child: const Center(
                  child: CircularProgressIndicator(
                backgroundColor: primaryColor,
                color: Colors.white,
              )),
            );
          }
        },
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
              child: BottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                          return DeleteModal(
                            title: '스크랩이',
                            text: '등록된 스크랩을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                            tapFunc: () async {
                              await CozyLogApiService().bulkUnscrapCozyLog(
                                scrapListModifyState.selectedIds,
                              );
                              setState(() {
                                cozyLogWrapper = CozyLogApiService()
                                    .getScrapCozyLogs(null, 10);
                                scrapListModifyState.clearSelection();
                              });
                            },
                          );
                        },
                        barrierDismissible: false,
                      );
                    },
                  );
                },
              ),
            )
          : null,
    );
  }
}
