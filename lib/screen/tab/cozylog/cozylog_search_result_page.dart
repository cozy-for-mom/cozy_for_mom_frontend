import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
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

  @override
  void initState() {
    super.initState();
    response = CozyLogApiService()
        .searchCozyLogs(widget.searchKeyword, null, 15, sortType);
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
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
                    );
                  } else {
                    return Container();
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                height: 650,
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
            ),
          ],
        ),
      ),
    );
  }
}
