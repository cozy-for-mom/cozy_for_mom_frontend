import 'package:cozy_for_mom_frontend/screen/mypage/baby_register_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_text_button.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/profile_modify.dart';
import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;
  late int daysPassed;
  late double percentage;
  late BabyProfile? selectedProfile;

  @override
  Widget build(BuildContext context) {
    // 디데이 그래프 계산
    int totalDays = 280; // 임신일 ~ 출산일
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: userViewModel.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantInfo = snapshot.data!;
            daysPassed = totalDays - (pregnantInfo['dDay'] as int);
            percentage = daysPassed / totalDays;
            if (percentage < 0) percentage = 1; // TODO 방어로직.
            selectedProfile = pregnantInfo['recentBabyProfile'];
            print(selectedProfile!.babies.first.babyId);
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
            ));
          }

          return Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image(
                    width: screenWidth - 40,
                    fit: BoxFit.cover,
                    image: const AssetImage(
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
                    pregnantInfo['imageUrl'] == null ?
                    Image.asset(
                      'assets/images/icons/momProfile.png',
                      fit: BoxFit.cover, // 이미지를 화면에 맞게 조절
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                    ) : ClipOval(
                      child: Image.network(
                        pregnantInfo['imageUrl'],
                         fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${pregnantInfo['nickname']} 산모님",
                      style: const TextStyle(
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
                                builder: (context) =>
                                    const MomProfileModify()));
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
                      width: screenWidth - 40,
                      height: 114, // TODO 화면 높이에 맞춘 height로 수정해야함
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${pregnantInfo['recentBabyProfile'].babies[0].babyName}와 만나는 날",
                                style: const TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              Text(' D-${pregnantInfo['dDay']}',
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                            ],
                          ),
                          Container(
                            width: screenWidth - 80,
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
                      width: screenWidth - 40,
                      height: 102, // TODO 화면 높이에 맞춘 height로 수정해야함
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextButton(
                              text: '내 코지로그',
                              textColor: mainTextColor,
                              textWeight: FontWeight.w600,
                              imagePath: 'assets/images/icons/cozylog.png',
                              imageWidth: 27.3,
                              imageHeight: 24.34,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyCozylog()));
                              }),
                          Container(
                            width: 1,
                            height: 42,
                            color: const Color(0xffE8E8ED),
                          ),
                          CustomTextButton(
                              text: '스크랩 내역',
                              textColor: mainTextColor,
                              textWeight: FontWeight.w600,
                              imagePath: 'assets/images/icons/scrap.png',
                              imageWidth: 18.4,
                              imageHeight: 24,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyScrap()));
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
                        width: screenWidth - 40,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            print("편집 클릭");
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
                                        itemCount: pregnantInfo['babyProfiles']
                                                .length +
                                            1, // 프로필 개수 + 추가 버튼
                                        itemBuilder: (context, index) {
                                          if (index ==
                                              pregnantInfo['babyProfiles']
                                                  .length) {
                                            // 추가 버튼 항목
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BabyRegisterScreen(),
                                                    ),
                                                  );
                                                });
                                              },
                                              child: InkWell(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 0, 10, 10),
                                                      child: Image.asset(
                                                        'assets/images/icons/plusDotted.png',
                                                        width: 80,
                                                        height: 80,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return CustomProfileButton(
                                              text: pregnantInfo['babyProfiles']
                                                      [index]
                                                  .babies
                                                  .map((baby) => baby.babyName)
                                                  .join('/'),
                                              imagePath:
                                                  pregnantInfo['babyProfiles']
                                                          [index]
                                                      .babyProfileImageUrl,
                                              offBackColor:
                                                  const Color(0xffF8F8FA),
                                              onPressed: () async {
                                                try {
                                                  await userViewModel
                                                      .modifyMainBaby(pregnantInfo[
                                                                  'babyProfiles']
                                                              [index]
                                                          .babyProfileId);
                                                  setState(() {
                                                    selectedProfile =
                                                        pregnantInfo[
                                                                'babyProfiles']
                                                            [index];
                                                    pregnantInfo[
                                                            'recentBabyProfile'] =
                                                        pregnantInfo[
                                                                'babyProfiles']
                                                            [index];
                                                  });
                                                  print(
                                                      'id:${selectedProfile!.babyProfileId} ${selectedProfile!.babies.map((baby) => baby.babyName)} 태아로 변경되었습니다.');
                                                } catch (e) {
                                                  // 에러 처리
                                                  print('프로필 변경 실패: $e');
                                                }
                                              },
                                              isSelected: pregnantInfo[
                                                          'recentBabyProfile'] !=
                                                      null &&
                                                  pregnantInfo[
                                                              'recentBabyProfile']
                                                          .babyProfileId ==
                                                      pregnantInfo[
                                                                  'babyProfiles']
                                                              [index]
                                                          .babyProfileId,
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
        });
  }
}
