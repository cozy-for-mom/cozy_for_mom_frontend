import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_scrap_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class ScrapListModify extends StatefulWidget {
  final List<ScrapForList> cozyLogs;
  final int totalCount;

  const ScrapListModify({
    super.key,
    this.cozyLogs = const [],
    required this.totalCount,
  });

  @override
  State<ScrapListModify> createState() => _ScrapListModifyState();
}

class _ScrapListModifyState extends State<ScrapListModify> {
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListModifyState>(context, listen: false).clearSelection();
    });
    cozyLogWrapper = CozyLogApiService().getScrapCozyLogs(context, null, 10);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // totalCount 사용하여 데이터 변경 감지
    if (oldWidget.totalCount != widget.totalCount) {
      pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    ListModifyState scrapListModifyState = context.watch<ListModifyState>();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: paddingValue,
              right: paddingValue,
              top: isTablet ? 15.w : 0.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            width: screenWidth - 2 * paddingValue,
            height: min(53.w, 83),
            decoration: BoxDecoration(
                color: const Color(0xffF0F0F5),
                borderRadius: BorderRadius.circular(30.w)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Image(
                        image:
                            const AssetImage('assets/images/icons/scrap.png'),
                        width: min(18.4.w, 28.4),
                        height: min(24.w, 34)),
                    SizedBox(width: 8.w),
                    Consumer<ListModifyState>(
                      builder: (context, cozylogListModifyState, child) {
                        return Text(
                          '${scrapListModifyState.selectedCount}/${widget.totalCount}',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(14.sp, 24)),
                        );
                      },
                    ),
                  ]),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          var allIds =
                              await CozyLogApiService().getAllScrapIds(context);
                          scrapListModifyState.selectedCount > 0
                              ? scrapListModifyState.clearSelection()
                              : scrapListModifyState
                                  .setCozylogAllSelected(allIds);
                          setState(() {
                            isAllSelected = !isAllSelected;
                          });
                        },
                        child: Text(
                            scrapListModifyState.selectedCount > 0
                                ? '전체해제'
                                : '전체선택',
                            style: TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: min(14.sp, 24))),
                      ),
                      SizedBox(width: 24.w),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyScrap()));
                        },
                        child: Text('편집완료',
                            style: TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: min(14.sp, 24))),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
        SizedBox(height: 22.w),
        widget.cozyLogs.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    left: paddingValue,
                    right: paddingValue,
                    bottom: 80.w - paddingValue),
                child: Container(
                  width: screenWidth - paddingValue,
                  // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                  height: screenHeight * (0.69),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      color: contentBoxTwoColor),
                  child: PagedListView<int, ScrapForList>(
                    // physics: const NeverScrollableScrollPhysics(),
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate<ScrapForList>(
                      itemBuilder: (context, item, index) {
                        bool isLast =
                            index == pagingController.itemList!.length - 1;
                        return ScrapViewWidget(
                          isLast: isLast,
                          cozylog: item,
                          isEditMode: true,
                          isMyCozyLog: true,
                          listModifyState: scrapListModifyState,
                          onSelectedChanged: (isAllSelected) {
                            scrapListModifyState.toggleSelected(item.id);
                            setState(() {});
                          },
                          // onUpdate: () {
                          //   setState(() {
                          //     pagingController.refresh();
                          //     cozyLogWrapper = CozyLogApiService()
                          //         .getScrapCozyLogs(context, null, 10);
                          //   });
                          // },
                        );
                      },
                    ),
                  ),
                ))
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
  }
}
