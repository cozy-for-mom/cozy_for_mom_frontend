import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_text_button.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:cozy_for_mom_frontend/model/baby_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/propfile_modify.dart';

ValueNotifier<BabyProfile?> selectedProfile = ValueNotifier<BabyProfile?>(null);

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

int babyId = 1;

class _MyPageState extends State<MyPage> {
  List<BabyProfile> profiles = [
    BabyProfile(
        babyId: babyId++,
        name: "미룽이",
        image: 'assets/images/icons/babyProfileOn.png'),
    BabyProfile(
        babyId: babyId++,
        name: "행운이",
        image: 'assets/images/icons/babyProfileOn.png')
  ];

  @override
  Widget build(BuildContext context) {
    final DateTime dueDate = DateTime(2024, 2, 11); // TODO 출산 예정일 DB에서 받아와야 함
    DateTime now = DateTime.now(); // 현재 날짜
    Duration difference = dueDate.difference(now);

    // 디데이 그래프 계산
    double totalDays = 280.0; // 임신일 ~ 출산일
    double daysPassed = totalDays - difference.inDays.toDouble(); // 현재 날짜 ~ 출산일
    double percentage = daysPassed / totalDays;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image(
              width: 390, // TODO 화면 너비에 맞춘 width로 수정해야함
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/subtract.png",
              ),
            ),
          ),
          Positioned(
            top: 47,
            left: 348,
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // 현재 화면을 닫음
                }),
          ),
          Positioned(
            top: 119,
            left: 0,
            right: 0,
            child: Column(children: [
              Image.asset(
                'assets/images/icons/momProfile.png',
                fit: BoxFit.contain, // 이미지를 화면에 맞게 조절
                width: 100,
                height: 100,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "쥬쥬 산모님",
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MomProfileModify()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "프로필 수정",
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 4),
                    Image.asset('assets/images/icons/pen.png', width: 12),
                  ],
                ),
              ),
            ]),
          ),
          // const SizedBox(height: 20),
          Positioned(
            top: 303,
            left: 11,
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              margin: const EdgeInsets.all(10),
              color: contentBoxTwoColor,
              child: SizedBox(
                width: 349, // TODO 화면 너비에 맞춘 width로 수정해야함
                height: 114, // TODO 화면 높이에 맞춘 height로 수정해야함
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "미룽이와 만나는 날",
                          style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        Text(' D-${difference.inDays}',
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                      ],
                    ),
                    Container(
                      width: 313, // TODO 화면 너비에 맞춘 width로 수정해야함
                      height: 12, // TODO 화면 높이에 맞춘 height로 수정해야함
                      decoration: BoxDecoration(
                        color: lineTwoColor, // 전체 배경색
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: percentage,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 434,
            left: 10,
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              margin: const EdgeInsets.all(10),
              color: contentBoxTwoColor,
              child: SizedBox(
                width: 350, // TODO 화면 너비에 맞춘 width로 수정해야함
                height: 102, // TODO 화면 높이에 맞춘 height로 수정해야함
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextButton(
                        text: '코지로그',
                        imagePath: 'assets/images/icons/cozylog.png',
                        imageWidth: 27.3,
                        imageHeight: 24.34,
                        onPressed: () {
                          // TODO 코지로그 페이지 이동 구현해야 함
                          print('코지로그 버튼 클릭됨');
                        }),
                    Container(
                      width: 1, // 수직선의 두께 조절
                      height: 42, // 수직선의 높이 조절
                      color: const Color(0xffE8E8ED),
                    ),
                    CustomTextButton(
                        text: '스크랩 내역',
                        imagePath: 'assets/images/icons/scrap.png',
                        imageWidth: 18.4,
                        imageHeight: 24,
                        onPressed: () {
                          // TODO 스크랩 내역 페이지 이동 구현해야함
                          print('스크랩 내역 버튼 클릭됨');
                        }),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 552,
            left: 10,
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              margin: const EdgeInsets.all(10),
              color: contentBoxTwoColor,
              child: SizedBox(
                  width: 350, // TODO 화면 너비에 맞춘 width로 수정해야함
                  height: 222, // TODO 화면 높이에 맞춘 height로 수정해야함
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 312,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("우리 아이 관리",
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18)),
                                Container(
                                  width: 42,
                                  height: 21,
                                  decoration: BoxDecoration(
                                    color: contentBoxColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      print("편집 버튼 클릭");
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                              EdgeInsetsGeometry>(
                                          EdgeInsets.zero), // 패딩을 없애는 부분
                                    ),
                                    child: const Text("편집",
                                        style: TextStyle(
                                            color: offButtonTextColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      profiles.length + 1, // 프로필 개수 + 추가 버튼
                                  itemBuilder: (context, index) {
                                    if (index == profiles.length) {
                                      // 추가 버튼 항목
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            print("태아 프로필 추가 버튼 클릭");
                                            // TODO 태아 프로필 추가 페이지 이동 구현해야 함
                                            profiles.add(BabyProfile(
                                              babyId: babyId++,
                                              name: "아룽이",
                                              image:
                                                  "assets/images/babyProfileTest.jpeg",
                                            ));
                                          });
                                        },
                                        child: InkWell(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 10),
                                                child: Image.asset(
                                                  'assets/images/icons/plusDotted.png',
                                                  width: 80,
                                                  height: 80,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ValueListenableBuilder<
                                          BabyProfile?>(
                                        valueListenable: selectedProfile,
                                        builder:
                                            (context, activeProfile, child) {
                                          return CustomProfileButton(
                                            text: profiles[index].name,
                                            imagePath: profiles[index].image,
                                            isSelected: activeProfile ==
                                                profiles[index],
                                            onPressed: () {
                                              selectedProfile.value =
                                                  profiles[index]; // 프로필 활성화
                                              print(
                                                  'id:${profiles[index].babyId} ${profiles[index].name} 버튼이 클릭되었습니다.');
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                )),
                          ),
                        ],
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
