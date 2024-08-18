import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_local_storage_service.dart';
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
  late Future<CozyLogSearchResponse> response;
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
    response = CozyLogApiService()
        .searchCozyLogs(widget.searchKeyword, null, 15, sortType);
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
      final response = await CozyLogApiService().searchCozyLogs(
        widget.searchKeyword,
        pageKey,
        15,
        sortType,
      );
      final cozyLogs = response.results;
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
    final searchController = TextEditingController(text: widget.searchKeyword);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 37,
                  width: 316,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 17,
                      ),
                      const Image(
                        image:
                            AssetImage("assets/images/icons/icon_search.png"),
                        width: 15,
                        height: 15,
                      ),
                      const SizedBox(
                        width: 10,
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
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: response,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.totalElements > 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 350,
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  title: const Center(
                                                      child: Text(
                                                    '최신순',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )),
                                                  onTap: () {
                                                    setState(() {
                                                      sortType =
                                                          CozyLogSearchSortType
                                                              .time;
                                                      response = CozyLogApiService()
                                                          .searchCozyLogs(
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
                                                width: 350,
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20)),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  title: const Center(
                                                      child: Text(
                                                    '댓글순',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )),
                                                  onTap: () {
                                                    setState(() {
                                                      sortType =
                                                          CozyLogSearchSortType
                                                              .comment;
                                                      response = CozyLogApiService()
                                                          .searchCozyLogs(
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
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 350,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    color: const Color(0xffC2C4CB),
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    "취소",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
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
                                    const Image(
                                      image: AssetImage(
                                          "assets/images/icons/icon_switch.png"),
                                      width: 15,
                                      height: 15,
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
                        SizedBox(height: 20,),
                        Container(
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: PagedListView(
                  pagingController: pagingController,
                  padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                  ),
                  builderDelegate:
                          PagedChildBuilderDelegate<CozyLogSearchResult>(
                        itemBuilder: (context, item, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CozyLogDetailScreen(
                                  id: item.id,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          item.summary,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff858998),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          dateFormat.format(item.date),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffAAAAAA),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                "assets/images/icons/icon_comment.png",
                                              ),
                                              width: 13,
                                              height: 13,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "댓글 ${item.commentCount}",
                                              style: const TextStyle(
                                                color: Color(0xffAAAAAA),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            const Image(
                                              image: AssetImage(
                                                  "assets/images/icons/icon_scrap.png"),
                                              width: 13,
                                              height: 13,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "스크랩 ${item.scrapCount}",
                                              style: const TextStyle(
                                                color: Color(0xffAAAAAA),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  item.imageUrl != null
                                      ? Flexible(
                                          flex: 3,
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Stack(children: [
                                              Image.network(
                                                item.imageUrl!,
                                                fit: BoxFit.cover,
                                                width: 88,
                                                height: 88,
                                              ),
                                              Positioned(
                                                top: 5,
                                                right: 5,
                                                child: Container(
                                                  width: 24,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      item.imageCount.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
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
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                thickness: 1,
                                color: Color(0xffE1E1E7),
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
                const Text(
                  "최근 검색",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 100,
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
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        storageService.clearRecentSearches();
                        setState(() {
                          recentSearches = [];
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    autoSave
                        ? InkWell(
                            child: const Text(
                              "자동저장 끄기",
                              style: TextStyle(
                                color: Color(0xff858998),
                                fontSize: 12,
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
                            child: const Text(
                              "자동저장 켜기",
                              style: TextStyle(
                                color: Color(0xff858998),
                                fontSize: 12,
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color(0xffF0F0F5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                recentSearches[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                height: 8,
                                width: 8,
                                child: InkWell(
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/images/icons/icon_close.png"),
                                    width: 8,
                                    height: 8,
                                  ),
                                  onTap: () {
                                    deleteSearch(recentSearches[index]);
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
            const SizedBox(
              height: 180,
            ),
            const Image(
              image: AssetImage("assets/images/icons/icon_search.png"),
              width: 44,
              height: 44,
              color: Color(0xffCBCBD3),
            ),
            const SizedBox(
              height: 17,
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
            const SizedBox(
              height: 20,
            ),
            
          ],
        ),
      ),
    );
  }
}
