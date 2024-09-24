import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_result_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_local_storage_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CozyLogSearchPage extends StatefulWidget {
  const CozyLogSearchPage({super.key});

  @override
  State<CozyLogSearchPage> createState() => _CozyLogSearchPageState();
}

class _CozyLogSearchPageState extends State<CozyLogSearchPage>
    with WidgetsBindingObserver {
  List<String> recentSearches = [];
  late CozyLogLocalStorageService storageService;
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
      await storageService.addRecentSearch(search); // 검색어 추가
    }

    await loadRecentSearches(); // 업데이트
  }

  Future<void> deleteSearch(String search) async {
    await storageService.deleteRecentSearch(search); // 특정 검색어 삭제
    await loadRecentSearches(); // 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 키보드가 활성화 상태인지 체크하고 키보드를 내립니다.
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.all(AppUtils.scaleSize(context, 8)),
          child: Column(
            children: [
              SizedBox(
                height: AppUtils.scaleSize(context, 70),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          width: AppUtils.scaleSize(context, 15),
                        ),
                        SizedBox(
                          width: AppUtils.scaleSize(context, 255),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            keyboardType: TextInputType.text,
                            cursorColor: primaryColor,
                            cursorHeight: AppUtils.scaleSize(context, 15),
                            decoration: InputDecoration(
                              // underline과의 기본 패딩값 없애기(텍스트 중앙정렬 위해)
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                              focusColor: primaryColor,
                              fillColor: primaryColor,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: const Color(0xff858998),
                                fontWeight: FontWeight.w400,
                                fontSize: AppUtils.scaleSize(context, 14),
                              ),
                              hintText: "검색어를 입력해주세요",
                            ),
                            maxLines: 1,
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: AppUtils.scaleSize(context, 14)),
                            onSubmitted: (String value) async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CozyLogSearchResultPage(
                                    searchKeyword: value,
                                  ),
                                ),
                              );
                              if (res == true) {
                                setState(() {
                                  addSearch(value);
                                });
                              }
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
                    child: Center(
                      child: Text(
                        "취소",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: AppUtils.scaleSize(context, 14),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 25),
              ),
              // 최근 검색
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
                          "전체삭제",
                          style: TextStyle(
                            color: recentSearches.isNotEmpty
                                ? const Color(0xff858998)
                                : const Color(0xffD8DAE2),
                            fontWeight: FontWeight.w500,
                            fontSize: AppUtils.scaleSize(context, 12),
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppUtils.scaleSize(context, 12),
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
                                  fontSize: AppUtils.scaleSize(context, 12),
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
                          horizontal: AppUtils.scaleSize(context, 5),
                          vertical: AppUtils.scaleSize(context, 10),
                        ),
                        child: Container(
                          height: AppUtils.scaleSize(context, 30),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color(0xffF0F0F5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppUtils.scaleSize(context, 12),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CozyLogSearchResultPage(
                                          searchKeyword: recentSearches[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    recentSearches[index],
                                    style: TextStyle(
                                      fontSize: AppUtils.scaleSize(context, 14),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: AppUtils.scaleSize(context, 12)),
                                SizedBox(
                                  height: AppUtils.scaleSize(context, 8),
                                  width: AppUtils.scaleSize(context, 8),
                                  child: InkWell(
                                    child: Image(
                                      image: const AssetImage(
                                          "assets/images/icons/icon_close.png"),
                                      width: AppUtils.scaleSize(context, 8),
                                      height: AppUtils.scaleSize(context, 8),
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
              SizedBox(
                height: AppUtils.scaleSize(context, 180),
              ),
              Image(
                image: const AssetImage("assets/images/icons/icon_search.png"),
                width: AppUtils.scaleSize(context, 44),
                height: AppUtils.scaleSize(context, 44),
                color: const Color(0xffCBCBD3),
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 17),
              ),
              Text(
                "검색어를 입력해보세요!",
                style: TextStyle(
                  color: const Color(0xff9397A4),
                  fontWeight: FontWeight.w500,
                  fontSize: AppUtils.scaleSize(context, 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
