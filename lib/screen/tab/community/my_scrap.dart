import 'package:cozy_for_mom_frontend/screen/tab/community/scrap_modify.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/scrap_view.dart';
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
import 'package:cozy_for_mom_frontend/common/widget/bottom_button_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_main.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';

class MyScrap extends StatefulWidget {
  final bool isEditMode;
  const MyScrap({super.key, this.isEditMode = false});

  @override
  State<MyScrap> createState() => _MyScrapState();
}

class _MyScrapState extends State<MyScrap> {
  late Future<ScrapCozyLogListWrapper> cozyLogWrapper;

  PagingController<int, CozyLogForList> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      // print("fetch Page $pageKey");
      final cozyLogWrapper =
          await CozyLogApiService().getScrapCozyLogs(pageKey, 5);
      final cozyLogs = cozyLogWrapper.cozyLogs;
      final isLastPage = cozyLogs.length < 5;

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
    cozyLogWrapper = CozyLogApiService().getScrapCozyLogs(null, 5);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            title: const Text('스크랩',
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
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
          // TODO
          SliverToBoxAdapter(
              child: FutureBuilder(
            future: cozyLogWrapper,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return widget.isEditMode
                    ? ScrapListModify(
                        cozyLogs: snapshot.data!.cozyLogs,
                        totalCount: snapshot.data!.totalCount,
                      )
                    : ScrapListView(
                        cozyLogs: snapshot.data!.cozyLogs,
                        totalCount: snapshot.data!.totalCount,
                      );
              } else {
                return const Text("코지로그를 스크랩해보세요"); // TODO
              }
            },
          )),
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
                    ListModifyState scrapListModifyState =
                        context.watch<ListModifyState>();
                    int selectedCount = scrapListModifyState.selectedCount;

                    bool isAnySelected = selectedCount > 0;

                    return BottomButtonWidget(
                      isActivated: isAnySelected,
                      text: '스크랩 삭제',
                      tapped: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteModal(
                              title: '스크랩이',
                              text: '등록된 스크랩을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                              onPressed: () async {
                                await CozyLogApiService().bulkUnscrapCozyLog(
                                  scrapListModifyState.selectedIds,
                                );
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyScrap()));
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
