import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/recent_cozylog_search_view.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_local_storage_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CozyLogSearchResultPage extends StatefulWidget {
  final String searchKeyword;
  const CozyLogSearchResultPage({
    super.key,
    required this.searchKeyword,
  });

  @override
  State<CozyLogSearchResultPage> createState() =>
      _CozyLogSearchResultPageState();
}

class _CozyLogSearchResultPageState extends State<CozyLogSearchResultPage> {
  late Future<CozyLogSearchResponse?> res;
  CozyLogSearchSortType sortType = CozyLogSearchSortType.time;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  PagingController<int, CozyLogSearchResult> pagingController =
      PagingController(firstPageKey: 0);
  late CozyLogLocalStorageService storageService;
  List<String> recentSearches = [];
  bool autoSave = false;

  @override
  void initState() {
    super.initState();
    res = CozyLogApiService()
        .searchCozyLogs(context, widget.searchKeyword, null, 15, sortType);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    initializeStorageService(); // 서비스 초기화
  }

  Future<void> initializeStorageService() async {
    storageService =
        await CozyLogLocalStorageService.getInstance(); // 인스턴스 가져오기
    storageService.getAutoSave().then((value) => autoSave = value);
    await loadRecentSearches(); // 최근 검색어 로드
  }

  Future<void> loadRecentSearches() async {
    List<String> searches =
        await storageService.getRecentSearches(); // 최근 검색어 가져오기
    setState(() {
      recentSearches = searches; // UI 업데이트
    });
  }

  Future<void> deleteSearch(String search) async {
    await storageService.deleteRecentSearch(search); // 특정 검색어 삭제
    await loadRecentSearches(); // 업데이트
  }

  Future<void> addSearch(String search) async {
    if (autoSave) {
      return await storageService.addRecentSearch(search); // 검색어 추가
    }

    await loadRecentSearches(); // 업데이트
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final res = await CozyLogApiService().searchCozyLogs(
        context,
        widget.searchKeyword,
        pageKey,
        15,
        sortType,
      );
      final cozyLogs = res!.results;
      final isLastPage = cozyLogs.length < 15;

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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    final searchController = TextEditingController(text: widget.searchKeyword);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
            left: paddingValue, right: paddingValue, top: paddingValue),
        child: Column(
          children: [
            SizedBox(
              height: isTablet ? 0.w : 50.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: min(37.w, 57),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.w),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 17.w,
                      ),
                      Image(
                        image: const AssetImage(
                            "assets/images/icons/icon_search.png"),
                        width: min(15.w, 25),
                        height: min(15.w, 25),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10.w),
                        width: 255.w,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              widget.searchKeyword,
                              maxLines: 1,
                              style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: min(14.sp, 24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Center(
                    child: Text(
                      "취소",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: min(14.sp, 24),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            FutureBuilder(
                future: res,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.totalElements > 0) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${snapshot.data!.totalElements.toString()}건",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: min(14.sp, 24),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0.0,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: isTablet
                                              ? 234.w - paddingValue
                                              : 234.w,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.w),
                                                width: screenWidth -
                                                    2 * paddingValue,
                                                height: 148.w - paddingValue,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.w),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        ListTile(
                                                          title: Center(
                                                              child: Text(
                                                            '최신순',
                                                            style: TextStyle(
                                                              color:
                                                                  mainTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: min(
                                                                  16.sp, 26),
                                                            ),
                                                          )),
                                                          onTap: () {
                                                            setState(() {
                                                              sortType =
                                                                  CozyLogSearchSortType
                                                                      .time;
                                                              res = CozyLogApiService()
                                                                  .searchCozyLogs(
                                                                context,
                                                                widget
                                                                    .searchKeyword,
                                                                0,
                                                                15,
                                                                sortType,
                                                              );
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        ListTile(
                                                          title: Center(
                                                              child: Text(
                                                            '댓글순',
                                                            style: TextStyle(
                                                                color:
                                                                    mainTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: min(
                                                                    16.sp, 26)),
                                                          )),
                                                          onTap: () {
                                                            setState(() {
                                                              sortType =
                                                                  CozyLogSearchSortType
                                                                      .comment;
                                                              res = CozyLogApiService()
                                                                  .searchCozyLogs(
                                                                context,
                                                                widget
                                                                    .searchKeyword,
                                                                0,
                                                                15,
                                                                CozyLogSearchSortType
                                                                    .comment, // TODO API 다시 확인 요청
                                                              );
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.w,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: screenWidth -
                                                      2 * paddingValue,
                                                  height: min(56.w, 96),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.w),
                                                    color: induceButtonColor,
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    "취소",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: min(16.sp, 26),
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          "assets/images/icons/icon_switch.png"),
                                      width: min(15.w, 25),
                                      height: min(15.w, 25),
                                    ),
                                    Text(
                                      " ${sortType.name}",
                                      style: TextStyle(
                                        color: const Color(0xff928C8C),
                                        fontWeight: FontWeight.w400,
                                        fontSize: min(14.sp, 24),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Container(
                            width: screenWidth - 2 * paddingValue,
                            // height: totalHeight, // TODO 컨테이너도 같이 페이지에이션?되도록, 무한스크롤되도록 수정하기
                            height: screenHeight * (0.75),
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w),
                              color: contentBoxTwoColor,
                            ),
                            child: PagedListView<int, CozyLogSearchResult>(
                              pagingController: pagingController,
                              padding: EdgeInsets.zero, // 기본 패딩 제거
                              builderDelegate: PagedChildBuilderDelegate<
                                  CozyLogSearchResult>(
                                itemBuilder: (context, item, index) {
                                  bool isLast = index ==
                                      pagingController.itemList!.length - 1;
                                  return CozylogSearchViewWidget(
                                    isLast: isLast,
                                    cozylog: item,
                                    isMyCozyLog: true,
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "최근 검색",
                                style: TextStyle(
                                  color: mainTextColor,
                                  fontSize: min(18.sp, 28),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 100.w,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Text(
                                      "전체 삭제",
                                      style: TextStyle(
                                        color: recentSearches.isNotEmpty
                                            ? const Color(0xff858998)
                                            : const Color(0xffD8DAE2),
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(12.sp, 22),
                                      ),
                                    ),
                                    onTap: () {
                                      storageService.clearRecentSearches();
                                      setState(() {
                                        recentSearches = [];
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  autoSave
                                      ? InkWell(
                                          child: Text(
                                            "자동저장 끄기",
                                            style: TextStyle(
                                              color: const Color(0xff858998),
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(12.sp, 22),
                                            ),
                                          ),
                                          onTap: () {
                                            storageService.setAutoSave(false);
                                            setState(() {
                                              autoSave = false;
                                            });
                                          },
                                        )
                                      : InkWell(
                                          child: Text(
                                            "자동저장 켜기",
                                            style: TextStyle(
                                              color: const Color(0xff858998),
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(12.sp, 22),
                                            ),
                                          ),
                                          onTap: () {
                                            storageService.setAutoSave(true);
                                            setState(() {
                                              autoSave = true;
                                            });
                                          },
                                        ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(  // TODO 결과 페이지에서도 태그 필요한지 확인하기
                          //   height: 10.w,
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 8.w,
                          //   ),
                          //   child: SizedBox(
                          //     height: 50.w,
                          //     child: ListView.builder(
                          //       scrollDirection: Axis.horizontal,
                          //       itemCount: recentSearches.length,
                          //       itemBuilder: (context, index) {
                          //         return Padding(
                          //           padding: EdgeInsets.symmetric(
                          //             horizontal: 5.w,
                          //             vertical: 10.w,
                          //           ),
                          //           child: Container(
                          //             height: 30.w,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(20.w)),
                          //               color: const Color(0xffF0F0F5),
                          //             ),
                          //             child: Padding(
                          //               padding: EdgeInsets.symmetric(
                          //                 horizontal: 12.w,
                          //               ),
                          //               child: Row(
                          //                 children: [
                          //                   Text(
                          //                     recentSearches[index],
                          //                     style: TextStyle(
                          //                       fontSize: min(14.sp, 24),
                          //                     ),
                          //                   ),
                          //                   SizedBox(
                          //                     width: 12.w,
                          //                   ),
                          //                   SizedBox(
                          //                     height: min(8.w, 16),
                          //                     width: min(8.w, 16),
                          //                     child: InkWell(
                          //                       child: Image(
                          //                         image: const AssetImage(
                          //                             "assets/images/icons/icon_close.png"),
                          //                         width: min(8.w, 16),
                          //                         height: min(8.w, 16),
                          //                       ),
                          //                       onTap: () {
                          //                         deleteSearch(
                          //                             recentSearches[index]);
                          //                       },
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: min(265.w, 360),
                          ),
                          Image(
                            image: const AssetImage(
                                "assets/images/icons/icon_search.png"),
                            width: min(44.w, 88),
                            height: min(44.w, 88),
                            color: const Color(0xffCBCBD3),
                          ),
                          SizedBox(height: 12.w),
                          Text(
                            "일치하는 검색결과가 없습니다.",
                            style: TextStyle(
                                color: const Color(0xff9397A4),
                                fontWeight: FontWeight.w500,
                                fontSize: min(14.sp, 24)),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Container();
                  }
                }),
            SizedBox(
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
