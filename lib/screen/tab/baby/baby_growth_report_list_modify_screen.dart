import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
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

    ListModifyState babyGrowthReportListModifyState =
        context.watch<ListModifyState>();

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppUtils.scaleSize(context, 20)),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppUtils.scaleSize(context, 24)),
            width: screenWidth - AppUtils.scaleSize(context, 40),
            height: AppUtils.scaleSize(context, 53),
            decoration: BoxDecoration(
                color: const Color(0xffF0F0F5),
                borderRadius: BorderRadius.circular(30)),
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
                              fontSize: AppUtils.scaleSize(context, 14)),
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
                                fontSize: AppUtils.scaleSize(context, 14))),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
        SizedBox(height: AppUtils.scaleSize(context, 22)),
        widget.babyProfileGrowths.isNotEmpty
            ? Container(
                width: screenWidth - AppUtils.scaleSize(context, 40),
                // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                height: screenHeight * (0.7),
                padding: EdgeInsets.symmetric(
                    horizontal: AppUtils.scaleSize(context, 20)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: contentBoxTwoColor),
                child: PagedListView<int, BabyProfileGrowth>(
                  padding: EdgeInsets.only(
                    top: AppUtils.scaleSize(context, 10),
                  ),
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<BabyProfileGrowth>(
                      itemBuilder: (context, item, index) {
                    final report = item;
                    final dateTime = report.date;
                    return SizedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: AppUtils.scaleSize(context, 10)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: AppUtils.scaleSize(context, 20)),
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
                                      width: AppUtils.scaleSize(context, 20),
                                      height: AppUtils.scaleSize(context, 20),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: AppUtils.scaleSize(context, 255),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: item.growthImageUrl == null
                                            ? AppUtils.scaleSize(context, 240)
                                            : AppUtils.scaleSize(context, 155),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              report.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: AppUtils.scaleSize(
                                                    context, 16),
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff2B2D35),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 5),
                                            ),
                                            Text(
                                              "${dateTime.year}. ${dateTime.month}. ${dateTime.day}.",
                                              style: TextStyle(
                                                fontSize: AppUtils.scaleSize(
                                                    context, 13),
                                                color: const Color(0xffAAAAAA),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 7),
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 36),
                                              child: Text(
                                                report.diary,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: AppUtils.scaleSize(
                                                      context, 12),
                                                  color:
                                                      const Color(0xff858998),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            AppUtils.scaleSize(context, 3)),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: report.growthImageUrl == null
                                              ? Container()
                                              : Image.network(
                                                  report.growthImageUrl!,
                                                  width: AppUtils.scaleSize(
                                                      context, 79),
                                                  height: AppUtils.scaleSize(
                                                      context, 79),
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
                              height: AppUtils.scaleSize(context, 10),
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
                      width: AppUtils.scaleSize(context, 45.31),
                      height: AppUtils.scaleSize(context, 44.35),
                    ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 15),
                    ),
                    const Text(
                      "태아의 검진기록을 입력해보세요!",
                      style: TextStyle(
                        color: Color(0xff9397A4),
                      ),
                    ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 140),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
