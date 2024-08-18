import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class CozylogListModify extends StatefulWidget {
  final List<CozyLogForList> cozyLogs;
  final int totalCount;
  const CozylogListModify({
    super.key,
    this.cozyLogs = const [],
    required this.totalCount,
  });

  @override
  State<CozylogListModify> createState() => _CozylogListModifyState();
}

class _CozylogListModifyState extends State<CozylogListModify> {
  late Future<MyCozyLogListWrapper> cozyLogWrapper;
  bool isAllSelected = false;

  PagingController<int, CozyLogForList> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final cozyLogWrapper =
          await CozyLogApiService().getMyCozyLogs(context, pageKey, 10);
      final cozyLogs = cozyLogWrapper.cozyLogs;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListModifyState>(context, listen: false).clearSelection();
    });
    cozyLogWrapper = CozyLogApiService().getMyCozyLogs(context, null, 10);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    // 코지로그 개수가 달라졌을 때(= 삭제했을 때), 리스트를 바로 업데이트할 수 있도록 구현한 코드(위젯의 구성이 변경될 때마다 호출)
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cozyLogs != widget.cozyLogs) {
      pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
    final totalHeight = boxHeight * widget.cozyLogs.length + 20;

    ListModifyState cozylogListModifyState = context.watch<ListModifyState>();

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
                    Image(
                        image:
                            const AssetImage('assets/images/icons/cozylog.png'),
                        width: AppUtils.scaleSize(context, 25.02),
                        height: AppUtils.scaleSize(context, 23.32)),
                    SizedBox(width: AppUtils.scaleSize(context, 8)),
                    Consumer<ListModifyState>(
                      builder: (context, cozylogListModifyState, child) {
                        return Text(
                          '${cozylogListModifyState.selectedCount}/${widget.totalCount}',
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
                        onTap: () {
                          cozylogListModifyState.selectedCount > 0
                              ? cozylogListModifyState.clearSelection()
                              : cozylogListModifyState
                                  .setAllSelected(widget.cozyLogs);
                          setState(() {
                            isAllSelected = !isAllSelected;
                          });
                        },
                        child: Text(
                            cozylogListModifyState.selectedCount > 0
                                ? '전체해제'
                                : '전체선택',
                            style: TextStyle(
                                color: offButtonTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: AppUtils.scaleSize(context, 14))),
                      ),
                      SizedBox(width: AppUtils.scaleSize(context, 24)),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyCozylog()));
                        },
                        child: Text('편집완료',
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
        widget.cozyLogs.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    left: AppUtils.scaleSize(context, 20),
                    right: AppUtils.scaleSize(context, 20),
                    bottom: AppUtils.scaleSize(context, 60)),
                child: Container(
                  width: screenWidth - AppUtils.scaleSize(context, 40),
                  // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                  height: screenHeight * (0.7),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppUtils.scaleSize(context, 20)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: contentBoxTwoColor),
                  child: PagedListView<int, CozyLogForList>(
                    // physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: screenHeight * 0.35),
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate<CozyLogForList>(
                      itemBuilder: (context, item, index) => CozylogViewWidget(
                        cozylog: item,
                        isEditMode: true,
                        isMyCozyLog: true,
                        listModifyState: cozylogListModifyState,
                        onSelectedChanged: (isAllSelected) {
                          cozylogListModifyState.toggleSelected(item.cozyLogId);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: AppUtils.scaleSize(context, 150),
                height: screenHeight * (0.6),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                          image: const AssetImage(
                              'assets/images/icons/scrap_off.png'),
                          width: AppUtils.scaleSize(context, 34.54),
                          height: AppUtils.scaleSize(context, 45.05)),
                      SizedBox(height: AppUtils.scaleSize(context, 12)),
                      Text('코지로그를 스크랩 해보세요!',
                          style: TextStyle(
                              color: const Color(0xff9397A4),
                              fontWeight: FontWeight.w500,
                              fontSize: AppUtils.scaleSize(context, 14))),
                    ]),
              ),
      ],
    );
  }
}
