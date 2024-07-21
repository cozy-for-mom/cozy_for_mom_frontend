import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_result_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_local_storage_service.dart';
import 'package:flutter/material.dart';

class CozyLogSearchPage extends StatefulWidget {
  const CozyLogSearchPage({super.key});

  @override
  State<CozyLogSearchPage> createState() => _CozyLogSearchPageState();
}

class _CozyLogSearchPageState extends State<CozyLogSearchPage> with WidgetsBindingObserver {
  List<String> recentSearches = [];
  late CozyLogLocalStorageService storageService;
  final TextEditingController _controller = TextEditingController();
  late final Future<List<String>> futureRecentFutureKeywords;
  bool autoSave = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeStorageService(); // 서비스 초기화
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initializeStorageService();
    }
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

  Future<void> addSearch(String search) async {
    if (autoSave) {
      return await storageService.addRecentSearch(search); // 검색어 추가
    }

    await loadRecentSearches(); // 업데이트
  }

  Future<void> deleteSearch(String search) async {
    await storageService.deleteRecentSearch(search); // 특정 검색어 삭제
    await loadRecentSearches(); // 업데이트
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
                            addSearch(value);
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text("취소"),
                  ),
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CozyLogSearchResultPage(
                                  searchKeyword: recentSearches[index],
                                ),
                              ),
                            );
                                },
                                child: Text(
                                  recentSearches[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
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
