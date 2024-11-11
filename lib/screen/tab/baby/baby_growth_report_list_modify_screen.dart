import 'dart:math';

import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class BabyGrowthReportListModify extends StatefulWidget {
  final List<BabyProfileGrowth> babyProfileGrowths;
  final int totalCount;
  const BabyGrowthReportListModify({
    super.key,
    this.babyProfileGrowths = const [],
    required this.totalCount,
  });

  @override
  State<BabyGrowthReportListModify> createState() =>
      _BabyGrowthReportListModifyState();
}

class _BabyGrowthReportListModifyState
    extends State<BabyGrowthReportListModify> {
  late Future<BabyProfileGrowthResult?> data;
  bool isAllSelected = false;
  late List<bool> isSelected;

  PagingController<int, BabyProfileGrowth> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final data = await BabyGrowthApiService()
          .getBabyProfileGrowths(context, pageKey, 10);

      setState(() {
        this.data = Future.value(data);
      });
      final growths = data!.growths;
      final isLastPage = growths.length < 10; // 10개 미만이면 마지막 페이지로 간주

      if (isLastPage) {
        pagingController.appendLastPage(growths);
      } else {
        final nextPageKey = data.lastId!; // 다음 페이지 키 설정
        pagingController.appendPage(growths, nextPageKey);
      }
    } catch (error) {
      print(error);
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListModifyState>(context, listen: false).clearSelection();
    });
    isSelected = List<bool>.generate(widget.totalCount, (index) => false);
    data = BabyGrowthApiService().getBabyProfileGrowths(context, null, 10);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // totalCount 사용하여 데이터 변경 감지
    // oldWidget.babyProfileGrowths.length와 widget.babyProfileGrowths.length를 비교하면 pagingController에 10개씩 불러오기때문에 변화 감지 못함
    if (oldWidget.totalCount != widget.totalCount) {
      pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
    final totalHeight = boxHeight * widget.babyProfileGrowths.length + 20;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    ListModifyState babyGrowthReportListModifyState =
        context.watch<ListModifyState>();

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
                    Consumer<ListModifyState>(
                      builder:
                          (context, babyGrowthReportListModifyState, child) {
                        return Text(
                          '${babyGrowthReportListModifyState.selectedCount}/${widget.totalCount}',
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
                              await BabyGrowthApiService().getAllGrowthIds(
                            context,
                          );
                          print(widget.babyProfileGrowths.length);
                          babyGrowthReportListModifyState.selectedCount > 0
                              ? babyGrowthReportListModifyState.clearSelection()
                              : babyGrowthReportListModifyState
                                  .setGrowthAllSelected(allIds);
                          setState(() {
                            isAllSelected = !isAllSelected;
                          });
                        },
                        child: Text(
                            babyGrowthReportListModifyState.selectedCount > 0
                                ? '전체해제'
                                : '전체선택',
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
        widget.babyProfileGrowths.isNotEmpty
            ? Container(
                width: screenWidth - 2 * paddingValue,
                // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                height: screenHeight * (0.7),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    color: contentBoxTwoColor),
                child: PagedListView<int, BabyProfileGrowth>(
                  padding: EdgeInsets.only(
                    top: 10.w,
                  ),
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<BabyProfileGrowth>(
                      itemBuilder: (context, item, index) {
                    final report = item;
                    final dateTime = report.date;
                    return SizedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSelected[index] = !isSelected[index];
                                        babyGrowthReportListModifyState
                                            .isSelected(item.id!);
                                        babyGrowthReportListModifyState
                                            .toggleSelected(item.id!);
                                      });
                                    },
                                    child: Image(
                                      image: babyGrowthReportListModifyState
                                              .isSelected(item.id!)
                                          ? const AssetImage(
                                              'assets/images/icons/select_on.png')
                                          : const AssetImage(
                                              'assets/images/icons/select_off.png'),
                                      width: min(20.w, 30),
                                      height: min(20.w, 30),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 255.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: item.growthImageUrl == null
                                            ? 240.w
                                            : 155.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              report.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: min(16.sp, 26),
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff2B2D35),
                                              ),
                                            ),
                                            SizedBox(height: 5.w),
                                            Text(
                                              "${dateTime.year}. ${dateTime.month}. ${dateTime.day}.",
                                              style: TextStyle(
                                                fontSize: min(13.sp, 23),
                                                color: const Color(0xffAAAAAA),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7.w,
                                            ),
                                            SizedBox(
                                              height: 36.w,
                                              child: Text(
                                                report.diary,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: min(12.sp, 22),
                                                  color:
                                                      const Color(0xff858998),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w, vertical: 3.w),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                          ),
                                          child: report.growthImageUrl == null
                                              ? Container()
                                              : Image.network(
                                                  report.growthImageUrl!,
                                                  width: min(79.w, 149),
                                                  height: min(79.w, 149),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            const Divider(
                              color: Color(0xffE1E1E7),
                              thickness: 1.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )
            : Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: const AssetImage(
                          "assets/images/icons/diary_inactive.png"),
                      width: min(45.31.w, 90.62),
                      height: min(44.35.w, 88.7),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    Text(
                      "태아의 검진기록을 입력해보세요!",
                      style: TextStyle(
                        color: const Color(0xff9397A4),
                        fontWeight: FontWeight.w500,
                        fontSize: min(14.w, 24),
                      ),
                    ),
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
