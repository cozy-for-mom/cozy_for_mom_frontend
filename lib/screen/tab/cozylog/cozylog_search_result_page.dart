import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_local_storage_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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
    final searchController = TextEditingController(text: widget.searchKeyword);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(AppUtils.scaleSize(context, 8)),
        child: Column(
          children: [
            SizedBox(
              height: AppUtils.scaleSize(context, 70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: AppUtils.scaleSize(context, 37),
                  width: AppUtils.scaleSize(context, 316),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppUtils.scaleSize(context, 17),
                      ),
                      Image(
                        image: const AssetImage(
                            "assets/images/icons/icon_search.png"),
                        width: AppUtils.scaleSize(context, 15),
                        height: AppUtils.scaleSize(context, 15),
                      ),
                      SizedBox(
                        width: AppUtils.scaleSize(context, 10),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.searchKeyword,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: const Center(
                    child: Text("취소"),
                  ),
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
            SizedBox(
              height: AppUtils.scaleSize(context, 20),
            ),
            FutureBuilder(
                future: res,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.totalElements > 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppUtils.scaleSize(context, 8)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${snapshot.data!.totalElements.toString()}건",
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: AppUtils.scaleSize(
                                                context, 200),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: screenWidth -
                                                      AppUtils.scaleSize(
                                                          context, 40),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color: Colors.white,
                                                  ),
                                                  child: ListTile(
                                                    title: const Center(
                                                        child: Text(
                                                      '최신순',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                                    onTap: () {
                                                      setState(() {
                                                        sortType =
                                                            CozyLogSearchSortType
                                                                .time;
                                                        res =
                                                            CozyLogApiService()
                                                                .searchCozyLogs(
                                                          context,
                                                          widget.searchKeyword,
                                                          0,
                                                          15,
                                                          sortType,
                                                        );
                                                      });

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  width: screenWidth -
                                                      AppUtils.scaleSize(
                                                          context, 40),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color: Colors.white,
                                                  ),
                                                  child: ListTile(
                                                    title: const Center(
                                                        child: Text(
                                                      '댓글순',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                                    onTap: () {
                                                      setState(() {
                                                        sortType =
                                                            CozyLogSearchSortType
                                                                .comment;
                                                        res =
                                                            CozyLogApiService()
                                                                .searchCozyLogs(
                                                          context,
                                                          widget.searchKeyword,
                                                          0,
                                                          15,
                                                          CozyLogSearchSortType
                                                              .comment,
                                                        );
                                                      });

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: AppUtils.scaleSize(
                                                      context, 20),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: screenWidth -
                                                        AppUtils.scaleSize(
                                                            context, 40),
                                                    height: AppUtils.scaleSize(
                                                        context, 56),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: const Color(
                                                          0xffC2C4CB),
                                                    ),
                                                    child: const Center(
                                                        child: Text(
                                                      "취소",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                        width: AppUtils.scaleSize(context, 15),
                                        height: AppUtils.scaleSize(context, 15),
                                      ),
                                      Text(
                                        " ${sortType.name}",
                                        style: const TextStyle(
                                          color: Color(0xff928C8C),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: AppUtils.scaleSize(context, 20),
                            ),
                            Container(
                              height: AppUtils.scaleSize(context, 600),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: PagedListView(
                                pagingController: pagingController,
                                padding: EdgeInsets.all(
                                    AppUtils.scaleSize(context, 15)),
                                builderDelegate: PagedChildBuilderDelegate<
                                    CozyLogSearchResult>(
                                  itemBuilder: (context, item, index) =>
                                      InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CozyLogDetailScreen(
                                            id: item.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height:
                                              AppUtils.scaleSize(context, 12),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              flex: 7,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.title,
                                                    style: TextStyle(
                                                      fontSize:
                                                          AppUtils.scaleSize(
                                                              context, 16),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppUtils.scaleSize(
                                                        context, 10),
                                                  ),
                                                  Text(
                                                    item.summary,
                                                    style: TextStyle(
                                                      fontSize:
                                                          AppUtils.scaleSize(
                                                              context, 12),
                                                      color: const Color(
                                                          0xff858998),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppUtils.scaleSize(
                                                        context, 10),
                                                  ),
                                                  Text(
                                                    dateFormat
                                                        .format(item.date),
                                                    style: TextStyle(
                                                      fontSize:
                                                          AppUtils.scaleSize(
                                                              context, 12),
                                                      color: const Color(
                                                          0xffAAAAAA),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppUtils.scaleSize(
                                                        context, 10),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image(
                                                        image: const AssetImage(
                                                          "assets/images/icons/icon_comment.png",
                                                        ),
                                                        width:
                                                            AppUtils.scaleSize(
                                                                context, 13),
                                                        height:
                                                            AppUtils.scaleSize(
                                                                context, 13),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            AppUtils.scaleSize(
                                                                context, 5),
                                                      ),
                                                      Text(
                                                        "댓글 ${item.commentCount}",
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xffAAAAAA),
                                                          fontSize: AppUtils
                                                              .scaleSize(
                                                                  context, 12),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            AppUtils.scaleSize(
                                                                context, 15),
                                                      ),
                                                      Image(
                                                        image: const AssetImage(
                                                            "assets/images/icons/icon_scrap.png"),
                                                        width:
                                                            AppUtils.scaleSize(
                                                                context, 13),
                                                        height:
                                                            AppUtils.scaleSize(
                                                                context, 13),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            AppUtils.scaleSize(
                                                                context, 5),
                                                      ),
                                                      Text(
                                                        "스크랩 ${item.scrapCount}",
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xffAAAAAA),
                                                          fontSize: AppUtils
                                                              .scaleSize(
                                                                  context, 12),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppUtils.scaleSize(
                                                  context, 7),
                                            ),
                                            item.imageUrl != null
                                                ? Flexible(
                                                    flex: 3,
                                                    child: Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Stack(children: [
                                                        Image.network(
                                                          item.imageUrl!,
                                                          fit: BoxFit.cover,
                                                          width: AppUtils
                                                              .scaleSize(
                                                                  context, 88),
                                                          height: AppUtils
                                                              .scaleSize(
                                                                  context, 88),
                                                        ),
                                                        Positioned(
                                                          top: AppUtils
                                                              .scaleSize(
                                                                  context, 5),
                                                          right: AppUtils
                                                              .scaleSize(
                                                                  context, 5),
                                                          child: Container(
                                                            width: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    24),
                                                            height: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    18),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                item.imageCount
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              AppUtils.scaleSize(context, 10),
                                        ),
                                        Divider(
                                          thickness:
                                              AppUtils.scaleSize(context, 1),
                                          color: const Color(0xffE1E1E7),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "최근 검색",
                                style: TextStyle(
                                  fontSize: AppUtils.scaleSize(context, 18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: AppUtils.scaleSize(context, 100),
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
                                        fontSize:
                                            AppUtils.scaleSize(context, 12),
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
                                    width: AppUtils.scaleSize(context, 20),
                                  ),
                                  autoSave
                                      ? InkWell(
                                          child: Text(
                                            "자동저장 끄기",
                                            style: TextStyle(
                                              color: const Color(0xff858998),
                                              fontSize: AppUtils.scaleSize(
                                                  context, 12),
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
                                              fontSize: AppUtils.scaleSize(
                                                  context, 12),
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
                          SizedBox(
                            height: AppUtils.scaleSize(context, 10),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppUtils.scaleSize(context, 8),
                            ),
                            child: SizedBox(
                              height: AppUtils.scaleSize(context, 50),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: recentSearches.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 5),
                                      vertical: AppUtils.scaleSize(context, 10),
                                    ),
                                    child: Container(
                                      height: AppUtils.scaleSize(context, 30),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Color(0xffF0F0F5),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppUtils.scaleSize(context, 12),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              recentSearches[index],
                                              style: TextStyle(
                                                fontSize: AppUtils.scaleSize(
                                                    context, 14),
                                              ),
                                            ),
                                            SizedBox(
                                                width: AppUtils.scaleSize(
                                                    context, 12)),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 8),
                                              width: AppUtils.scaleSize(
                                                  context, 8),
                                              child: InkWell(
                                                child: Image(
                                                  image: const AssetImage(
                                                      "assets/images/icons/icon_close.png"),
                                                  width: AppUtils.scaleSize(
                                                      context, 8),
                                                  height: AppUtils.scaleSize(
                                                      context, 8),
                                                ),
                                                onTap: () {
                                                  deleteSearch(
                                                      recentSearches[index]);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 180),
                          ),
                          Image(
                            image: const AssetImage(
                                "assets/images/icons/icon_search.png"),
                            width: AppUtils.scaleSize(context, 44),
                            height: AppUtils.scaleSize(context, 44),
                            color: const Color(0xffCBCBD3),
                          ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 17),
                          ),
                          const Text(
                            "일치하는 검색결과가 없습니다.",
                            style: TextStyle(
                              color: Color(0xff9397A4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Container();
                  }
                }),
            SizedBox(
              height: AppUtils.scaleSize(context, 20),
            ),
          ],
        ),
      ),
    );
  }
}
