import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_result_page.dart';
import 'package:flutter/material.dart';

class CozyLogSearchPage extends StatefulWidget {
  const CozyLogSearchPage({super.key});

  @override
  State<CozyLogSearchPage> createState() => _CozyLogSearchPageState();
}

class _CozyLogSearchPageState extends State<CozyLogSearchPage> {
  // TODO 조회 API로 대체
  final searchHistories = ["체중", "임산부", "병원검사", "영양제", "임신"];
  final TextEditingController _controller = TextEditingController();

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
                      Expanded(
                        child: TextField(
                          cursorColor: primaryColor,
                          cursorHeight: 15,
                          decoration: const InputDecoration(
                            focusColor: primaryColor,
                            fillColor: primaryColor,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color(0xff858998),
                              fontSize: 14,
                              height: 19 / 14,
                            ),
                            hintText: "검색어를 입력해주세요",
                          ),
                          onSubmitted: (String value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CozyLogSearchResultPage(
                                  searchKeyword: value,
                                ),
                              ),
                            );
                          },
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
                    Navigator.of(context).pop(); // 팝업 닫기
                  },
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            // 최근 검색
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
                    Text(
                      "전체 삭제",
                      style: TextStyle(
                        color: searchHistories.isNotEmpty
                            ? const Color(0xff858998)
                            : const Color(0xffD8DAE2),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "자동저장 끄기",
                      style: TextStyle(
                        color: Color(0xff858998),
                        fontSize: 12,
                      ),
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
                  itemCount: searchHistories.length,
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
                                searchHistories[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const SizedBox(
                                height: 8,
                                width: 8,
                                child: InkWell(
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/icons/icon_close.png"),
                                    width: 8,
                                    height: 8,
                                  ),
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
              "검색어를 입력해보세요!",
              style: TextStyle(
                color: Color(0xff9397A4),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
