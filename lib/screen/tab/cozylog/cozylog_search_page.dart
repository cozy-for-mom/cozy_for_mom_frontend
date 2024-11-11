import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_search_result_page.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

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
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            children: [
              SizedBox(
                height: isTablet ? 0.w : 50.w,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: min(37.w, 57),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.w),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: Center(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: primaryColor,
                              cursorHeight: min(14.sp, 24),
                              decoration: InputDecoration(
                                focusColor: primaryColor,
                                fillColor: primaryColor,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: const Color(0xff858998),
                                  fontWeight: FontWeight.w400,
                                  fontSize: min(14.sp, 24),
                                ),
                                hintText: "검색어를 입력해주세요",
                              ),
                              maxLines: 1,
                              style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: min(14.sp, 24),
                              ),
                              onSubmitted: (String value) async {
                                final res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CozyLogSearchResultPage(
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
                          fontSize: min(14.sp, 24),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25.w,
              ),
              // 최근 검색
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "최근 검색",
                    style: TextStyle(
                      fontSize: min(18.sp, 28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
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
              SizedBox(
                height: 10.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                ),
                child: SizedBox(
                  height: min(50.w, 90),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentSearches.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 10.w,
                        ),
                        child: Container(
                          height: 30.w,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w)),
                            color: const Color(0xffF0F0F5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                                      fontSize: min(14.sp, 24),
                                    ),
                                  ),
                                ),
                                SizedBox(width: min(12.w, 22)),
                                SizedBox(
                                  child: InkWell(
                                    child: Image(
                                      image: const AssetImage(
                                          "assets/images/icons/icon_close.png"),
                                      width: min(8.w, 16),
                                      height: min(8.w, 16),
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
                height: min(195.w, 235),
              ),
              Image(
                image: const AssetImage("assets/images/icons/icon_search.png"),
                width: min(44.w, 88),
                height: min(44.w, 88),
                color: const Color(0xffCBCBD3),
              ),
              SizedBox(
                height: 17.w,
              ),
              Text(
                "검색어를 입력해보세요!",
                style: TextStyle(
                  color: const Color(0xff9397A4),
                  fontWeight: FontWeight.w500,
                  fontSize: min(14.sp, 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
