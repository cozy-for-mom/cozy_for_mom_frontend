import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/tab/community/recent_scrap_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/scrap_modify.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late Future<ScrapCozyLogListWrapper?> cozyLogWrapper;
  bool isAllSelected = false;

  PagingController<int, ScrapForList> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final cozyLogWrapper =
          await CozyLogApiService().getScrapCozyLogs(context, pageKey, 10);
      final cozyLogs = cozyLogWrapper!.cozyLogs;
      final isLastPage = cozyLogs.length < 10;

      if (isLastPage) {
        pagingController.appendLastPage(cozyLogs);
      } else {
        final nextPageKey = cozyLogs.lastOrNull?.id;
        pagingController.appendPage(cozyLogs, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  // 새로운 데이터를 가져와 cozyLogWrapper 갱신하는 함수
  Future<void> fetchCozyLogs() async {
    cozyLogWrapper = CozyLogApiService().getScrapCozyLogs(context, null, 10);
  }

  @override
  void initState() {
    super.initState();
    fetchCozyLogs();
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final boxHeight = (20 + 143.0).w; //screenHeight * (0.6);
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    ListModifyState scrapListModifyState = context.watch<ListModifyState>();
    int selectedCount = scrapListModifyState.selectedCount;
    bool isAnySelected = selectedCount > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0.0,
        title: Text(
          '스크랩',
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
            Navigator.of(context).pop();
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
      body: Stack(
        children: [
          FutureBuilder(
            future: cozyLogWrapper,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final totalHeight =
                    boxHeight * snapshot.data!.cozyLogs.length + paddingValue;
                return widget.isEditMode
                    ? ScrapListModify(
                        // TODO 왜 바로 ScrapListModify 안가고 MyScrap를 거쳐가는거지? 데이터 사용하려고?!
                        cozyLogs: snapshot.data!.cozyLogs,
                        totalCount: snapshot.data!.totalCount,
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: paddingValue,
                                right: paddingValue,
                                top: isTablet ? 15.w : 0.w),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 20.w : 24.w),
                              width: screenWidth - 2 * paddingValue,
                              height: min(53.w, 83),
                              decoration: BoxDecoration(
                                  color: const Color(0xffF0F0F5),
                                  borderRadius: BorderRadius.circular(30.w)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Image(
                                          image: const AssetImage(
                                              'assets/images/icons/scrap.png'),
                                          width: min(18.4.w, 28.4),
                                          height: min(24.w, 34)),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${snapshot.data!.totalCount}개의 스크랩',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: min(14.sp, 24)),
                                      ),
                                    ]),
                                    InkWell(
                                      onTap: () {
                                        snapshot.data!.cozyLogs.isNotEmpty
                                            ? setState(() {
                                                Navigator.pushReplacement(
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
                                      child: Text(
                                        '편집',
                                        style: TextStyle(
                                            color: offButtonTextColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: min(14.sp, 24)),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(height: 22.w),
                          snapshot.data!.cozyLogs.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingValue),
                                  child: Container(
                                    width: screenWidth - 2 * paddingValue,
                                    // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                                    height: screenHeight * (0.75),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.w),
                                      color: contentBoxTwoColor,
                                    ),
                                    child: PagedListView<int, ScrapForList>(
                                      pagingController: pagingController,
                                      builderDelegate:
                                          PagedChildBuilderDelegate<
                                              ScrapForList>(
                                        itemBuilder: (context, item, index) {
                                          bool isLast = index ==
                                              pagingController
                                                      .itemList!.length -
                                                  1;
                                          return ScrapViewWidget(
                                            isLast: isLast,
                                            cozylog: item,
                                            isEditMode: false,
                                            isMyCozyLog: true,
                                            onUpdate: () {
                                              setState(() {
                                                pagingController.refresh();
                                                fetchCozyLogs();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          image: const AssetImage(
                                              'assets/images/icons/scrap_off.png'),
                                          width: min(34.54.w, 79.08),
                                          height: min(45.05.w, 90.1)),
                                      SizedBox(
                                        height: 12.w,
                                      ),
                                      Text('코지로그를 스크랩 해보세요!',
                                          style: TextStyle(
                                              color: const Color(0xff9397A4),
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(14.sp, 24))),
                                      SizedBox(
                                        height: 140.w,
                                      ),
                                    ],
                                  ),
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
          widget.isEditMode
              ? Positioned(
                  bottom: 0.w,
                  left: 0.w,
                  right: 0.w,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: BottomButtonWidget(
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
                                  context,
                                  scrapListModifyState.selectedIds,
                                );
                                setState(() {
                                  cozyLogWrapper = CozyLogApiService()
                                      .getScrapCozyLogs(context, null, 10);
                                  scrapListModifyState.clearSelection();
                                });
                              },
                            );
                          },
                          barrierDismissible: false,
                        );
                      },
                    ),
                  ),
                )
              : Container(),
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
    );
  }
}
