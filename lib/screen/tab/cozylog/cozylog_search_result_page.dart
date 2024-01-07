import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:flutter/material.dart';

class CozyLogSearchResultPage extends StatefulWidget {
  const CozyLogSearchResultPage({super.key});

  @override
  State<CozyLogSearchResultPage> createState() =>
      _CozyLogSearchResultPageState();
}

class _CozyLogSearchResultPageState extends State<CozyLogSearchResultPage> {
  String searchKeyword = "과일";
  CozyLogSearchSortType sortType = CozyLogSearchSortType.comment;
  CozyLogSearchResponse result = CozyLogSearchResponse(
    results: [
      CozyLogSearchResult(
        id: 1,
        title: "과일 먹고싶은 새벽",
        summary: "새벽인데 과일이 너무 먹고싶어요 드라마에서 어쩌구저쩌구...",
        date: "2023-09-11",
        commentCount: 21,
        scrapCount: 0,
        imageCount: 0,
        imageUrl: null,
      ),
      CozyLogSearchResult(
        id: 2,
        title: "과일 싸게 사는 방법",
        summary: "임신 중에 유독 과일이 먹고싶더라고요 근데 요즘 과일 값이 금값이라 내키는대로",
        date: "2023-10-28",
        commentCount: 4,
        scrapCount: 10,
        imageCount: 1,
        imageUrl:
            "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/2a4t/image/w_yQeuiLSMJCqBEn7wiD__r07T4.jpg",
      ),
    ],
    totalElements: 33,
  );

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
                          searchKeyword,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const InkWell(
                  child: Center(
                    child: Text("취소"),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${result.totalElements.toString()}건",
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
                                          topRight: Radius.circular(20)),
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
                                              CozyLogSearchSortType.comment;
                                        });
                                        // TODO API 호출
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 350,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
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
                                          sortType = CozyLogSearchSortType.time;
                                        });
                                        // TODO API 호출
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
                                        borderRadius: BorderRadius.circular(12),
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
                          image:
                              AssetImage("assets/images/icons/icon_switch.png"),
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
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 650,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                itemCount: result.results.length,
                itemBuilder: (context, index) {
                  return Column(
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
                                  result.results[index].title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  result.results[index].summary,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff858998),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  result.results[index].date,
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
                                      "댓글 ${result.results[index].commentCount}",
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
                                      "스크랩 ${result.results[index].scrapCount}",
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
                          result.results[index].imageUrl != null
                              ? Flexible(
                                  flex: 3,
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(children: [
                                      Image.network(
                                        result.results[index].imageUrl!,
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
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              result.results[index].imageCount
                                                  .toString(),
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
