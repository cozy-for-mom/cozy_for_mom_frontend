import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';

class UserDeleteScreen extends StatefulWidget {
  const UserDeleteScreen({super.key});

  @override
  State<UserDeleteScreen> createState() => _UserDeleteScreenState();
}

class _UserDeleteScreenState extends State<UserDeleteScreen> {
  final deletedReasons = [
    "아기가 찾아오면 다시 올게요.",
    "원하는 기능이 없어요.",
    "사용을 잘 안하게 돼요.",
    "새 계정을 만들고 싶어요.",
    "기타",
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "코지포맘",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "탈퇴 사유를 알려주세요.",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              "회원 탈퇴 사유를 알려주세요. 추후 서비스 개선에 중요한\n자료로 참고하겠습니다.",
              style: TextStyle(
                color: Color(0xff8C909E),
                height: 1.3,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: deletedReasons.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7FA),
                        borderRadius: BorderRadius.circular(10),
                        border: selectedIndex == index
                            ? Border.all(
                                color: primaryColor,
                              )
                            : null,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (selectedIndex == index) {
                            setState(() {
                              selectedIndex = null;
                            });
                          } else {
                            setState(() {
                              selectedIndex = index;
                            });
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: selectedIndex == index
                                      ? primaryColor
                                      : const Color(0xffD9D9D9),
                                  size: 18,
                                  weight: 5,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  deletedReasons[index],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: selectedIndex == index
                                        ? Colors.black
                                        : const Color(0xff858998),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {
                print("등록 버튼 클릭"); // TODO 등록 버튼 클릭 시 실행문 구현
              },
              child: Container(
                width: 350, // TODO
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: selectedIndex == null
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black,
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  "회원 탈퇴",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
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
