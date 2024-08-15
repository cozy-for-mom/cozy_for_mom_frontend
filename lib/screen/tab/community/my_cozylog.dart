import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
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
  final bool ispop;
  const MyCozylog({super.key, this.isEditMode = false, this.ispop = false});

  @override
  State<MyCozylog> createState() => _MyCozylogState();
}

class _MyCozylogState extends State<MyCozylog> {
  late Future<MyCozyLogListWrapper> cozyLogWrapper;

  PagingController<int, CozyLogForList> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final cozyLogWrapper =
          await CozyLogApiService().getMyCozyLogs(pageKey, 10);
      setState(() {
        this.cozyLogWrapper = Future.value(cozyLogWrapper);
      });
      final cozyLogs = cozyLogWrapper.cozyLogs;
      final isLastPage = cozyLogs.length < 10; // 10개 미만이면 마지막 페이지로 간주
      if (isLastPage) {
        pagingController.appendLastPage(cozyLogs);
      } else {
        final nextPageKey = cozyLogs.last.cozyLogId + 1; // 다음 페이지 키 설정
        pagingController.appendPage(cozyLogs, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    cozyLogWrapper = CozyLogApiService().getMyCozyLogs(null, 10);
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
        title: Text(
          '내 코지로그',
          style: TextStyle(
              color: mainTextColor,
              fontWeight: FontWeight.w600,
              fontSize: AppUtils.scaleSize(context, 18)),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            widget.ispop
                ? Navigator.pop(context)
                : Navigator.push(
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
            child: Image(
                width: AppUtils.scaleSize(context, 20),
                height: AppUtils.scaleSize(context, 20),
                image: const AssetImage("assets/images/icons/icon_search.png")),
          ),
          IconButton(
            icon: Image(
              width: AppUtils.scaleSize(context, 24),
              height: AppUtils.scaleSize(context, 24),
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
      body: FutureBuilder(
        future: cozyLogWrapper,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final totalHeight = boxHeight * snapshot.data!.cozyLogs.length + 20;
            return widget.isEditMode
                ? CozylogListModify(
                    // TODO 왜 바로 CozylogListModify로 안가고 MyCozyLog를 거쳐가는거지? 데이터 사용하려고?!
                    cozyLogs: snapshot.data!.cozyLogs,
                    totalCount: snapshot.data!.totalCount,
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppUtils.scaleSize(context, 20)),
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
                                      image: const AssetImage(
                                          'assets/images/icons/cozylog.png'),
                                      width: AppUtils.scaleSize(context, 25.02),
                                      height:
                                          AppUtils.scaleSize(context, 23.32)),
                                  SizedBox(
                                      width: AppUtils.scaleSize(context, 8)),
                                  Text(
                                    '${snapshot.data!.totalCount}개의 코지로그',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            AppUtils.scaleSize(context, 14)),
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
                                        fontSize:
                                            AppUtils.scaleSize(context, 14)),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(height: AppUtils.scaleSize(context, 22)),
                      snapshot.data!.cozyLogs.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppUtils.scaleSize(context, 20)),
                              child: Container(
                                width: screenWidth -
                                    AppUtils.scaleSize(context, 40),
                                // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                                height: screenHeight * (0.75),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppUtils.scaleSize(context, 20)),
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
                              width: AppUtils.scaleSize(context, 150),
                              height: screenHeight * (0.6),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                        image: const AssetImage(
                                            'assets/images/icons/cozylog_off.png'),
                                        width:
                                            AppUtils.scaleSize(context, 45.31),
                                        height:
                                            AppUtils.scaleSize(context, 40.77)),
                                    SizedBox(
                                        height:
                                            AppUtils.scaleSize(context, 12)),
                                    Text('코지로그를 작성해 보세요!',
                                        style: TextStyle(
                                            color: const Color(0xff9397A4),
                                            fontWeight: FontWeight.w500,
                                            fontSize: AppUtils.scaleSize(
                                                context, 14))),
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
              width: screenWidth - AppUtils.scaleSize(context, 40),
              child: BottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onClosing: () {},
                builder: (BuildContext context) {
                  ListModifyState cozylogListModifyState =
                      context.watch<ListModifyState>();
                  int selectedCount = cozylogListModifyState.selectedCount;

                  bool isAnySelected = selectedCount > 0;

                  return BottomButtonWidget(
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
                                  cozylogListModifyState.selectedIds);
                              setState(() {
                                cozyLogWrapper =
                                    CozyLogApiService().getMyCozyLogs(null, 10);
                                cozylogListModifyState.clearSelection();
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
