import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CozyLogListScreen extends StatefulWidget {
  const CozyLogListScreen({super.key});

  @override
  State<CozyLogListScreen> createState() => _CozyLogListScreenState();
}

class _CozyLogListScreenState extends State<CozyLogListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<CozyLogForList>?> cozyLogListFuture;
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
        CozyLogApiService().getCozyLogs(context, null, 10, sortType: type);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      cozyLogListFuture =
          CozyLogApiService().getCozyLogs(context, pageKey, 10, sortType: type);
      final cozyLogs = await cozyLogListFuture;
      final isLastPage = cozyLogs!.length < 10;

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
            cozyLogListFuture =
                CozyLogApiService().getCozyLogs(context, null, 10);
            type = 'LATELY';
            pagingController.refresh();
          });
          break;
        case 1:
          setState(() {
            cozyLogListFuture = CozyLogApiService()
                .getCozyLogs(context, null, 10, sortType: "HOT");
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
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;
    final boxHeight = (20 + 143.0).w; //screenHeight * (0.6);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          '코지로그',
          style: TextStyle(
              color: mainTextColor,
              fontWeight: FontWeight.w600,
              fontSize: min(18.sp, 28)),
        ),
        leading: IconButton(
          icon: Image(
            image: const AssetImage('assets/images/icons/back_ios.png'),
            width: min(34.w, 44),
            height: min(34.w, 44),
            color: mainTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
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
            child: Image(
                width: min(20.w, 30),
                height: min(20.w, 30),
                image: const AssetImage("assets/images/icons/icon_search.png")),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: paddingValue,
                right: paddingValue,
                top: screenWidth > 600 ? 15.w : 0.w),
            child: TabBar(
              controller: tabController,
              labelColor: primaryColor,
              indicatorColor: primaryColor,
              labelStyle: TextStyle(
                fontSize: min(18.sp, 28),
                fontWeight: FontWeight.w600,
              ),
              dividerColor: mainLineColor,
              unselectedLabelStyle: TextStyle(
                fontSize: min(18.sp, 28),
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
                final totalHeight =
                    boxHeight * snapshot.data!.length + paddingValue;
                return Column(
                  children: [
                    SizedBox(height: 22.w),
                    snapshot.data!.isNotEmpty
                        ? Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: paddingValue),
                            child: Container(
                              width: screenWidth - 40.w,
                              // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                              height: screenHeight * (0.75),
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.w),
                                color: contentBoxTwoColor,
                              ),
                              child: PagedListView<int, CozyLogForList>(
                                // physics: const NeverScrollableScrollPhysics(),
                                pagingController: pagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<CozyLogForList>(
                                        itemBuilder: (context, item, index) {
                                  bool isLast = index ==
                                      pagingController.itemList!.length - 1;
                                  return CozylogViewWidget(
                                    isLast: isLast,
                                    cozylog: item,
                                    isEditMode: false,
                                    isMyCozyLog: true, // TODO 수정 필요
                                    onUpdate: () {
                                      setState(() {
                                        pagingController.refresh();
                                      });
                                    },
                                  );
                                }),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 150.w,
                            height: screenHeight * (0.6),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                      image: const AssetImage(
                                          'assets/images/icons/cozylog_off.png'),
                                      width: min(45.31.w, 90.62),
                                      height: min(40.77.w, 40.77*2)),
                                  SizedBox(height: 12.w),
                                  Text('코지로그를 작성해 보세요!',
                                      style: TextStyle(
                                          color: const Color(0xff9397A4),
                                          fontWeight: FontWeight.w500,
                                          fontSize: min(14.sp, 24))),
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
        ],
      ),
    );
  }
}
