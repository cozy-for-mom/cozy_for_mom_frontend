import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/bottom_button_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/baby/grow_report_register.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_list_modify_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';

class BabyGrowthReportListScreen extends StatefulWidget {
  const BabyGrowthReportListScreen({super.key});

  @override
  State<BabyGrowthReportListScreen> createState() =>
      _BabyGrowthReportListScreenState();
}

class _BabyGrowthReportListScreenState
    extends State<BabyGrowthReportListScreen> {
  DateFormat dateFormat = DateFormat('yyyy년 MM월 dd일');
  late Future<BabyProfileGrowthResult?> data;
  String nextCheckUpDate = "";
  DateFormat dateFormatForString = DateFormat('yyyy-MM-dd');
  bool isEditMode = false;

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
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    data = BabyGrowthApiService().getBabyProfileGrowths(context, null, 10);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ListModifyState babyGrowthReportListModifyState =
        context.watch<ListModifyState>();
    int selectedCount = babyGrowthReportListModifyState.selectedCount;
    bool isAnySelected = selectedCount > 0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          "성장 보고서",
          style: TextStyle(
            color: mainTextColor,
            fontWeight: FontWeight.w600,
            fontSize: AppUtils.scaleSize(context, 20),
          ),
        ),
        leading: IconButton(
          icon: Image(
            image: const AssetImage('assets/images/icons/back_ios.png'),
            width: AppUtils.scaleSize(context, 34),
            height: AppUtils.scaleSize(context, 34),
            color: mainTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          InkWell(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                  right: AppUtils.scaleSize(context, 20),
                ),
                alignment: Alignment.center,
                width: AppUtils.scaleSize(context, 53),
                height: AppUtils.scaleSize(context, 29),
                decoration: BoxDecoration(
                  color: isEditMode ? primaryColor : induceButtonColor,
                  borderRadius: BorderRadius.circular(33),
                ),
                child: Text(
                  isEditMode ? '완료' : '편집',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scaleSize(context, 12)),
                ),
              ),
            ),
            onTap: () async {
              setState(() {
                isEditMode = !isEditMode;
                pagingController.refresh();
              });
            },
          ),
        ],
      ),
      floatingActionButton: isEditMode
          ? null
          : CustomFloatingButton(
              pressed: () async {
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const GrowReportRegister(babyProfileGrowth: null),
                  ),
                );

                if (res == true) {
                  setState(() {
                    pagingController.refresh();
                  });
                }
              },
            ),
      body: Consumer<MyDataModel>(builder: (context, globalData, _) {
        return Stack(
          children: [
            FutureBuilder(
                future: data,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.nextExaminationDate != null) {
                      nextCheckUpDate =
                          dateFormat.format(snapshot.data.nextExaminationDate);
                    }
                    return isEditMode
                        ? BabyGrowthReportListModify(
                            babyProfileGrowths: snapshot.data!.growths,
                            totalCount: snapshot.data!.totalCount,
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUtils.scaleSize(context, 20)),
                            child: Column(
                              children: [
                                Container(
                                  width: screenWidth -
                                      AppUtils.scaleSize(context, 40),
                                  height: AppUtils.scaleSize(context, 53),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 24)),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF0F0F5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "다음 검진일",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                          fontSize:
                                              AppUtils.scaleSize(context, 14),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0.0,
                                            context: context,
                                            builder: (context) {
                                              List<String>
                                                  selectedNotifications = [];

                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  void toggleOffNotification(
                                                      String notification) {
                                                    setState(() {
                                                      if (selectedNotifications
                                                          .contains(
                                                              notification)) {
                                                        selectedNotifications
                                                            .remove(
                                                                notification);
                                                      }
                                                    });
                                                  }

                                                  void toggleNotification(
                                                      String notification) {
                                                    setState(() {
                                                      if (selectedNotifications
                                                          .contains(
                                                              notification)) {
                                                        selectedNotifications
                                                            .remove(
                                                                notification);
                                                      } else {
                                                        selectedNotifications
                                                            .add(notification);
                                                        if (notification !=
                                                            'none') {
                                                          toggleOffNotification(
                                                              "none");
                                                        } else {
                                                          toggleOffNotification(
                                                              "on day");
                                                          toggleOffNotification(
                                                              "one day ago");
                                                          toggleOffNotification(
                                                              "two day ago");
                                                          toggleOffNotification(
                                                              "one week ago");
                                                        }
                                                      }
                                                    });
                                                  }

                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        MonthCalendarModal(
                                                            firstToday: true),
                                                        Container(
                                                          color: Colors.white,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .all(AppUtils
                                                                        .scaleSize(
                                                                            context,
                                                                            8)),
                                                                child: Divider(
                                                                  height: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          30),
                                                                  thickness: 1,
                                                                  color: const Color(
                                                                      0xffE2E2E2),
                                                                ),
                                                              ),
                                                              Text(
                                                                "알림",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      mainTextColor,
                                                                  fontSize: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          16),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          20)),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        AppUtils.scaleSize(
                                                                            context,
                                                                            10)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    NotificationOption(
                                                                        title:
                                                                            '당일 정오',
                                                                        isSelected:
                                                                            selectedNotifications.contains(
                                                                                "on day"),
                                                                        onTap: () =>
                                                                            {
                                                                              toggleNotification("on day")
                                                                            }),
                                                                    NotificationOption(
                                                                      title:
                                                                          '하루 전',
                                                                      isSelected:
                                                                          selectedNotifications
                                                                              .contains("one day ago"),
                                                                      onTap: () =>
                                                                          toggleNotification(
                                                                              "one day ago"),
                                                                    ),
                                                                    NotificationOption(
                                                                      title:
                                                                          '이틀 전',
                                                                      isSelected:
                                                                          selectedNotifications
                                                                              .contains("two day ago"),
                                                                      onTap: () =>
                                                                          toggleNotification(
                                                                              "two day ago"),
                                                                    ),
                                                                    NotificationOption(
                                                                      title:
                                                                          '일주일 전',
                                                                      isSelected:
                                                                          selectedNotifications
                                                                              .contains("one week ago"),
                                                                      onTap: () =>
                                                                          toggleNotification(
                                                                              "one week ago"),
                                                                    ),
                                                                    NotificationOption(
                                                                      title:
                                                                          '설정 안 함',
                                                                      isSelected:
                                                                          selectedNotifications
                                                                              .contains("none"),
                                                                      onTap: () =>
                                                                          toggleNotification(
                                                                              "none"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          30)),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .bottomCenter,
                                                                    end: Alignment
                                                                        .topCenter,
                                                                    colors: [
                                                                      Colors
                                                                          .white,
                                                                      Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.2),
                                                                    ],
                                                                  ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          20),
                                                                  bottom: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          34),
                                                                ),
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    if (selectedNotifications
                                                                        .isNotEmpty) {
                                                                      await BabyGrowthApiService().registerNotificationExaminationDate(
                                                                          context,
                                                                          dateFormatForString
                                                                              .format(globalData.selectedDate),
                                                                          selectedNotifications);
                                                                      if (mounted) {
                                                                        // 비동기에서 context 관련 메소드 쓸 때, mounted로 한번 체크
                                                                        Navigator.pop(
                                                                            context,
                                                                            true);
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: AppUtils
                                                                        .scaleSize(
                                                                            context,
                                                                            56),
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                      horizontal:
                                                                          AppUtils.scaleSize(
                                                                              context,
                                                                              20),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                      color: selectedNotifications
                                                                              .isNotEmpty
                                                                          ? primaryColor
                                                                          : const Color(
                                                                              0xffC9DFF9),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "등록하기",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize: AppUtils.scaleSize(
                                                                              context,
                                                                              16),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ).then((value) {
                                            if (value == true) {
                                              setState(() {
                                                pagingController.refresh();
                                              });
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: AppUtils.scaleSize(
                                                  context, 5),
                                            ),
                                            nextCheckUpDate == ""
                                                ? Text(
                                                    "검진일 등록하기",
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xff858998),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            AppUtils.scaleSize(
                                                                context, 14)),
                                                  )
                                                : Text(
                                                    dateFormat.format(snapshot
                                                        .data
                                                        .nextExaminationDate),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            AppUtils.scaleSize(
                                                                context, 14)),
                                                  ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 13,
                                              color: Color(0xff858998),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: AppUtils.scaleSize(context, 22),
                                ),
                                snapshot.data.growths.isNotEmpty
                                    ? Container(
                                        width: screenWidth -
                                            AppUtils.scaleSize(context, 40),
                                        // height:
                                        //     totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                                        height: screenHeight * (0.75),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: AppUtils.scaleSize(
                                                context, 20)),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: contentBoxTwoColor,
                                        ),
                                        child: PagedListView<int,
                                            BabyProfileGrowth>(
                                          padding: EdgeInsets.only(
                                            top:
                                                AppUtils.scaleSize(context, 14),
                                          ),
                                          pagingController: pagingController,
                                          builderDelegate:
                                              PagedChildBuilderDelegate<
                                                      BabyProfileGrowth>(
                                                  itemBuilder:
                                                      (context, item, index) {
                                            final report = item;
                                            final dateTime = report.date;
                                            bool isLast = index ==
                                                pagingController
                                                        .itemList!.length -
                                                    1;
                                            return InkWell(
                                              onTap: () async {
                                                final res =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BabyGrowthReportDetailScreen(
                                                      babyProfileGrowthId:
                                                          report.id!,
                                                    ),
                                                  ),
                                                );

                                                if (res == true) {
                                                  setState(() {
                                                    pagingController.refresh();
                                                  });
                                                }
                                              },
                                              child: SizedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          AppUtils.scaleSize(
                                                              context, 10)),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            flex:
                                                                report.growthImageUrl ==
                                                                        null
                                                                    ? 10
                                                                    : 7,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  report.title,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: AppUtils
                                                                        .scaleSize(
                                                                            context,
                                                                            16),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: const Color(
                                                                        0xff2B2D35),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          5),
                                                                ),
                                                                Text(
                                                                  "${dateTime.year}. ${dateTime.month}. ${dateTime.day}.",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: AppUtils
                                                                        .scaleSize(
                                                                            context,
                                                                            13),
                                                                    color: const Color(
                                                                        0xffAAAAAA),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          7),
                                                                ),
                                                                SizedBox(
                                                                  height: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          36),
                                                                  child: Text(
                                                                    report
                                                                        .diary,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: AppUtils.scaleSize(
                                                                          context,
                                                                          12),
                                                                      color: const Color(
                                                                          0xff858998),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex:
                                                                report.growthImageUrl ==
                                                                        null
                                                                    ? 0
                                                                    : 3,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          3)),
                                                              child: Container(
                                                                clipBehavior:
                                                                    Clip.hardEdge,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: report
                                                                            .growthImageUrl ==
                                                                        null
                                                                    ? Container()
                                                                    : Image
                                                                        .network(
                                                                        report
                                                                            .growthImageUrl!,
                                                                        width: AppUtils.scaleSize(
                                                                            context,
                                                                            79),
                                                                        height: AppUtils.scaleSize(
                                                                            context,
                                                                            79),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            AppUtils.scaleSize(
                                                                context, 10),
                                                      ),
                                                      if (!isLast) // 마지막 요소가 아닐때만 구분선 출력
                                                        const Divider(
                                                          color:
                                                              Color(0xffE1E1E7),
                                                          thickness: 1.0,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      )
                                    : Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: const AssetImage(
                                                  "assets/images/icons/diary_inactive.png"),
                                              width: AppUtils.scaleSize(
                                                  context, 45.31),
                                              height: AppUtils.scaleSize(
                                                  context, 44.35),
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 15),
                                            ),
                                            const Text(
                                              "태아의 검진기록을 입력해보세요!",
                                              style: TextStyle(
                                                color: Color(0xff9397A4),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 140),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: primaryColor,
                      color: Colors.white,
                    ));
                  }
                }),
            isEditMode
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
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
                        text: '성장보고서 삭제',
                        tapped: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteModal(
                                title: '성장 보고서가',
                                text:
                                    '등록된 성장 보고서를 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                tapFunc: () async {
                                  await BabyGrowthApiService()
                                      .bulkDeleteBabyProfileGrowth(
                                          context,
                                          babyGrowthReportListModifyState
                                              .selectedIds);
                                  setState(() {
                                    data = BabyGrowthApiService()
                                        .getBabyProfileGrowths(
                                            context, null, 10);
                                    babyGrowthReportListModifyState
                                        .clearSelection();
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
        );
      }),
    );
  }
}

class NotificationOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NotificationOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppUtils.scaleSize(context, 3)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: AppUtils.scaleSize(context, 8),
              horizontal: AppUtils.scaleSize(context, 12)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: isSelected ? primaryColor : const Color(0xffF0F0F5),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppUtils.scaleSize(context, 12),
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
