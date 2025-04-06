import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
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
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_modify.dart';
import 'package:cozy_for_mom_frontend/common/widget/bottom_button_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class MyCozylog extends StatefulWidget {
  final bool isEditMode;
  const MyCozylog({super.key, this.isEditMode = false});

  @override
  State<MyCozylog> createState() => _MyCozylogState();
}

class _MyCozylogState extends State<MyCozylog> {
  late Future<MyCozyLogListWrapper?> cozyLogWrapper;

  PagingController<int, CozyLogForList> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final cozyLogWrapper =
          await CozyLogApiService().getMyCozyLogs(context, pageKey, 10);
      setState(() {
        this.cozyLogWrapper = Future.value(cozyLogWrapper);
      });
      final cozyLogs = cozyLogWrapper!.cozyLogs;
      final isLastPage = cozyLogs.length < 10; // 10개 미만이면 마지막 페이지로 간주
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

  @override
  void initState() {
    super.initState();
    cozyLogWrapper = CozyLogApiService().getMyCozyLogs(context, null, 10);
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
    ListModifyState cozylogListModifyState = context.watch<ListModifyState>();
    int selectedCount = cozylogListModifyState.selectedCount;
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
          '내 코지로그',
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
      body: Stack(
        children: [
          FutureBuilder(
            future: cozyLogWrapper,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final totalHeight =
                    boxHeight * snapshot.data!.cozyLogs.length + paddingValue;
                return widget.isEditMode
                    ? CozylogListModify(
                        // TODO 왜 바로 CozylogListModify로 안가고 MyCozyLog를 거쳐가는거지? 데이터 사용하려고?!
                        // cozyLogs: snapshot.data!.cozyLogs,
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
                                              'assets/images/icons/cozylog.png'),
                                          width: min(25.02.w, 35.02),
                                          height: min(23.32.w, 33.32)),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${snapshot.data!.totalCount}개의 코지로그',
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
                                                        const MyCozylog(
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
                                    child: PagedListView<int, CozyLogForList>(
                                      pagingController: pagingController,
                                      builderDelegate:
                                          PagedChildBuilderDelegate<
                                              CozyLogForList>(
                                        itemBuilder: (context, item, index) {
                                          bool isLast = index ==
                                              pagingController
                                                      .itemList!.length -
                                                  1;
                                          return CozylogViewWidget(
                                            isLast: isLast,
                                            cozylog: item,
                                            isEditMode: false,
                                            isMyCozyLog: true,
                                            onUpdate: () {
                                              setState(() {
                                                pagingController.refresh();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 150.w,
                                  height: screenHeight * (0.6),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                  bottom: 0.h,
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
                      text: '코지로그 삭제',
                      tapped: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteModal(
                              title: '코지로그가',
                              text: '등록된 코지로그를 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                              tapFunc: () async {
                                await CozyLogApiService().bulkDeleteCozyLog(
                                    context,
                                    cozylogListModifyState.selectedIds);
                                setState(() {
                                  cozyLogWrapper = CozyLogApiService()
                                      .getMyCozyLogs(context, null, 10);
                                  cozylogListModifyState.clearSelection();
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
              pressed: () async {
                final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CozylogRecordPage()));

                if (res == true) {
                  setState(() {
                    pagingController.refresh();
                  });
                }
              },
            ),
    );
  }
}
