import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_record.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_modify.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_view.dart';
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
  late Future<List<CozyLogForList>> cozyLogs;

  @override
  void initState() {
    super.initState();
    cozyLogs = CozyLogApiService().getCozyLogs(null, 10);
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
            backgroundColor: Colors.white,
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
              future: cozyLogs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return widget.isEditMode
                      ? CozylogListModify(cozyLogs: snapshot.data!)
                      : CozylogListView(
                          cozyLogs: snapshot.data!,
                          isMyCozyLog: true,
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
                            return const DeleteModal(
                              title: '코지로그가',
                              text: '등록된 코지로그를 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
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
