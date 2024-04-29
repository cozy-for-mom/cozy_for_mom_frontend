import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
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
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_modify.dart';
import 'package:cozy_for_mom_frontend/common/widget/bottom_button_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_main.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class MyCozylog extends StatefulWidget {
  final bool isEditMode;
  const MyCozylog({super.key, this.isEditMode = false});

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CozylogMain()));
              },
            ),
            title: const Text(
              '내 코지로그',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
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
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: cozyLogWrapper,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return widget.isEditMode
                      ? CozylogListModify(
                          cozyLogs: snapshot.data!.cozyLogs,
                          totalCount: snapshot.data!.totalCount,
                        )
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                width: screenWidth - 40,
                                height: 53,
                                decoration: BoxDecoration(
                                    color: const Color(0xffF0F0F5),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        const Image(
                                            image: AssetImage(
                                                'assets/images/icons/cozylog.png'),
                                            width: 25.02,
                                            height: 23.32),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${snapshot.data!.totalCount}개의 코지로그',
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
                                                  // isEditMode = !isEditMode;
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
                                      bottom: 60,
                                    ),
                                    child: Container(
                                      width: screenWidth - 40,
                                      height: boxHeight *
                                              snapshot.data!.cozyLogs.length +
                                          20,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: contentBoxTwoColor,
                                      ),
                                      child: PagedListView<int, CozyLogForList>(
                                        padding: EdgeInsets.zero,
                                        pagingController: pagingController,
                                        builderDelegate:
                                            PagedChildBuilderDelegate<
                                                CozyLogForList>(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                  return const Text("코지로그를 작성해보세요"); // TODO
                }
              },
            ),
          )
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
      bottomSheet: widget.isEditMode
          ? SizedBox(
              width: screenWidth - 40,
              child: Container(
                color: Colors.transparent,
                child: BottomSheet(
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
                              onPressed: () async {
                                await CozyLogApiService().bulkUnscrapCozyLog(
                                    []); // TODO 일괄 삭제 API로 변경
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyCozylog()),
                                );
                              },
                            );
                          },
                          barrierDismissible: false,
                        );
                      },
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }
}
