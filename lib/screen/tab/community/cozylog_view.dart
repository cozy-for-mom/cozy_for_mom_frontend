import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/recent_cozylog_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CozylogListView extends StatefulWidget {
  final List<CozyLogForList> cozyLogs;
  final bool isMyCozyLog;
  final int totalCount;
  const CozylogListView({
    super.key,
    this.cozyLogs = const [],
    this.isMyCozyLog = false,
    required this.totalCount,
  });

  @override
  State<CozylogListView> createState() => _CozylogListViewState();
}

final PagingController<int, CozyLogForList> _pagingController =
    PagingController(firstPageKey: 0);

class _CozylogListViewState extends State<CozylogListView> {
  bool isEditMode = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const boxHeight = 20 + 143.0; //screenHeight * (0.6);
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
                    Text(
                      '${widget.totalCount}개의 코지로그',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: AppUtils.scaleSize(context, 14)),
                    ),
                  ]),
                  InkWell(
                    onTap: () {
                      widget.cozyLogs.isNotEmpty
                          ? setState(() {
                              isEditMode = !isEditMode;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyCozylog(isEditMode: isEditMode)));
                            })
                          : setState(() {});
                    },
                    child: Text(
                      '편집',
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: AppUtils.scaleSize(context, 14)),
                    ),
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
                  height: boxHeight * widget.cozyLogs.length +
                      AppUtils.scaleSize(context, 20),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppUtils.scaleSize(context, 20)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: contentBoxTwoColor),
                  // child: PagedListView<int, CozyLogForList>(
                  //   pagingController: _pagingController,
                  //   builderDelegate: PagedChildBuilderDelegate<CozyLogForList>(
                  //     itemBuilder: (context, item, index) => CozylogViewWidget(
                  //       cozylog: item,
                  //       isEditMode: isEditMode,
                  //       isMyCozyLog: widget.isMyCozyLog,
                  //     ),
                  //   ),
                  // ),
                  child: Column(
                    children: widget.cozyLogs
                        .map((cozylog) => CozylogViewWidget(
                              cozylog: cozylog,
                              isEditMode: isEditMode,
                              isMyCozyLog: widget.isMyCozyLog,
                            ))
                        .toList(),
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
                          width: AppUtils.scaleSize(context, 45.31),
                          height: AppUtils.scaleSize(context, 40.77)),
                      SizedBox(height: AppUtils.scaleSize(context, 12)),
                      Text('코지로그를 작성해 보세요!',
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
