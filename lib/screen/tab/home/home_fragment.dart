import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_page.dart';
import 'package:cozy_for_mom_frontend/screen/mom/meal/meal_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/home/record_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/mypage_screen.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_record.dart';
import 'package:cozy_for_mom_frontend/screen/mom/weight/weight_record.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({
    super.key,
  });
  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    int nowHour = int.parse(DateFormat('HH').format(now));

    return FutureBuilder(
        future: userViewModel.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantInfo = snapshot.data!;
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ));
          }

          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Image(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    image: AssetImage(
                        // 아침: AM4 ~ PM12 / 점심(저녁): PM12 ~ PM8 / 밤: PM8 ~ AM4
                        nowHour >= 4 && nowHour < 12
                            ? "assets/images/home_morning.png"
                            : nowHour >= 12 && nowHour < 20
                                ? "assets/images/home_afternoon.png"
                                : "assets/images/home_evening.png"),
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
                            pregnantInfo['nickname'],
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
                Positioned(
                  top: 66,
                  left: 340,
                  child: IconButton(
                    icon: const Image(
                      width: 30,
                      height: 30,
                      image: AssetImage(
                        "assets/images/icons/mypage.png",
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyPage()));
                    },
                  ),
                ),
                Positioned(
                  top: 380,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 390, // TODO 화면 너비에 맞춘 width로 수정해야함
                    height: 600, // TODO 화면 높이에 맞춘 height로 수정해야함
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      color: contentBoxTwoColor,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 61,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MealScreen()));
                              },
                              child: const RecordIcon(
                                recordTypeName: "meal",
                                recordTypeKorName: "식단",
                                imageWidth: 26,
                                imageHeight: 37,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SupplementRecord()));
                                },
                                child: const RecordIcon(
                                  recordTypeName: "supplement",
                                  recordTypeKorName: "영양제",
                                  imageWidth: 28,
                                  imageHeight: 67,
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BloodsugarPage()));
                                },
                                child: const RecordIcon(
                                  recordTypeName: "bloodsugar",
                                  recordTypeKorName: "혈당",
                                  imageWidth: 28,
                                  imageHeight: 37,
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WeightRecord()));
                                },
                                child: const RecordIcon(
                                  recordTypeName: "weight",
                                  recordTypeKorName: "체중",
                                  imageWidth: 28,
                                  imageHeight: 37,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 44,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SupplementRecord(),
                              ),
                            );
                          },
                          child: Container(
                            width: 350,
                            height: 123,
                            decoration: const BoxDecoration(
                              color: Color(0xffEDF0FA),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9)),
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
        });
  }
}
