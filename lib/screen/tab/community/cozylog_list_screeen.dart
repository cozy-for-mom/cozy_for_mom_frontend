import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CozyLogListScreen extends StatefulWidget {
  const CozyLogListScreen({super.key});

  @override
  State<CozyLogListScreen> createState() => _CozyLogListScreenState();
}

class _CozyLogListScreenState extends State<CozyLogListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<CozyLogForList>> cozyLogListFuture;
  TabController? tabController;
  PagingController<int, CozyLogForList> pagingController =
      PagingController(firstPageKey: 0);
  String type = 'LATELY';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(handleTabSelection);
    cozyLogListFuture =
        CozyLogApiService().getCozyLogs(null, 10, sortType: type);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      cozyLogListFuture =
          CozyLogApiService().getCozyLogs(pageKey, 10, sortType: type);
      final cozyLogs = await cozyLogListFuture;
      final isLastPage = cozyLogs.length < 10;

      if (isLastPage) {
        pagingController.appendLastPage(cozyLogs);
      } else {
        final nextPageKey = cozyLogs.lastOrNull?.cozyLogId;
        pagingController.appendPage(cozyLogs, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void handleTabSelection() {
    if (tabController!.indexIsChanging) {
      switch (tabController!.index) {
        case 0:
          setState(() {
            cozyLogListFuture = CozyLogApiService().getCozyLogs(null, 10);
            type = 'LATELY';
            pagingController.refresh();
          });
          break;
        case 1:
          setState(() {
            cozyLogListFuture =
                CozyLogApiService().getCozyLogs(null, 10, sortType: "HOT");
            type = 'HOT';
            pagingController.refresh();
          });

          break;
      }
    }
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
        elevation: 0,
        title: const Text(
          '코지로그',
          style: TextStyle(
              color: mainTextColor, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TabBar(
              controller: tabController,
              labelColor: primaryColor,
              indicatorColor: primaryColor,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              dividerColor: mainLineColor,
              unselectedLabelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: mainTextColor,
              ),
              tabs: const [
                Tab(text: "최신글"),
                Tab(text: "인기글"),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),

          FutureBuilder(
            future: cozyLogListFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final totalHeight = boxHeight * snapshot.data!.length + 20;
                return Column(
                  children: [
                    const SizedBox(height: 22),
                    snapshot.data!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              // bottom: 60,
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
                                // physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.35),
                                pagingController: pagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<CozyLogForList>(
                                        itemBuilder: (context, item, index) {
                                  return CozylogViewWidget(
                                    cozylog: item,
                                    isEditMode: false,
                                    isMyCozyLog: true, // TODO 수정 필요
                                  );
                                }),
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
                          ),
                  ],
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: primaryColor,
                  color: Colors.white,
                ));
              }
            },
          ),
          // )
        ],
      ),
    );
  }
}
