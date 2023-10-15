import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/record_icon_widget.dart';
import 'package:flutter/material.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = User(1, "쥬쥬", "안소현");

    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            child: Image(
              width: 400, // TODO 화면 너비에 맞춘 width로 수정해야함
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/dark_sky.png",
              ),
            ),
          ),
          Positioned(
            top: 128,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.nickname,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      " ",
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    const Text(
                      "산모님,",
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "오늘도 안녕하세요",
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 66,
            left: 340,
            child: Image(
              width: 30,
              height: 30,
              image: AssetImage(
                "assets/images/icons/icon_baby.png",
              ),
            ),
          ),
          Positioned(
            top: 379,
            child: Container(
              width: 400, // TODO 화면 너비에 맞춘 width로 수정해야함
              height: 600, // TODO 화면 높이에 맞춘 height로 수정해야함
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 61,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RecordIcon(
                        recordTypeName: "meal",
                        recordTypeKorName: "식단",
                        imageWidth: 24,
                        imageHeight: 33,
                      ),
                      RecordIcon(
                        recordTypeName: "supplement",
                        recordTypeKorName: "영양제",
                        imageWidth: 14.72,
                        imageHeight: 33,
                      ),
                      RecordIcon(
                        recordTypeName: "bloodsugar",
                        recordTypeKorName: "혈당",
                        imageWidth: 23.14,
                        imageHeight: 33,
                      ),
                      RecordIcon(
                        recordTypeName: "weight",
                        recordTypeKorName: "체중",
                        imageWidth: 24.99,
                        imageHeight: 33,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  Container(
                    width: 350,
                    height: 123,
                    decoration: const BoxDecoration(
                      color: Color(0xffEDF0FA),
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 19,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "잊지 말고 기록하세요",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 11.34,
                            ),
                            Text(
                              "철분제는 챙겨드셨나요?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 49,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image(
                              image: AssetImage(
                                "assets/images/icons/icon_supplement.png",
                              ),
                              height: 43,
                              width: 19,
                            ),
                            Image(
                              image: AssetImage(
                                "assets/images/icons/icon_clock.png",
                              ),
                              height: 66,
                              width: 66,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 278,
            left: 85,
            width: 221,
            child: Image(
              image: AssetImage(
                "assets/images/baby.png",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
