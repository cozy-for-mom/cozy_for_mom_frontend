import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/mypage/baby_register_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    // 디데이 그래프 계산
    int totalDays = 280; // 임신일 ~ 출산일
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder(
          future: userViewModel.getUserInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              pregnantInfo = snapshot.data!;

              daysPassed = totalDays - (pregnantInfo['dDay'] as int);
              percentage = daysPassed / totalDays;
              if (percentage < 0) percentage = 1; // TODO 방어로직.
              selectedProfile = pregnantInfo['recentBabyProfile'];
            }
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: primaryColor,
                color: Colors.white,
              ));
            }

            return Stack(
              children: [
                Positioned(
                  top: isTablet ? -65.h : 0.h,
                  left: 0.w,
                  right: 0.w,
                  child: Image(
                    width: screenWidth - 2 * paddingValue,
                    fit: BoxFit.cover,
                    image: const AssetImage(
                      "assets/images/subtract.png",
                    ),
                  ),
                ),
                Positioned(
                  top: isTablet ? 27.h : 47.h,
                  right: 8.w,
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: min(28.w, 38),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                ),
                Positioned(
                  top: isTablet ? 109.h : 119.h,
                  left: 0.w,
                  right: 0.w,
                  child: SizedBox(
                    height: min(161.w, 300),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          pregnantInfo['imageUrl'] == null
                              ? Image.asset(
                                  'assets/images/icons/momProfile.png',
                                  fit: BoxFit.cover, // 이미지를 화면에 맞게 조절
                                  width: min(100.w, 200),
                                  height: min(100.w, 200),
                                  alignment: Alignment.center,
                                )
                              : ClipOval(
                                  child: Image.network(
                                    pregnantInfo['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: min(100.w, 200),
                                    height: min(100.w, 200),
                                  ),
                                ),
                          Text(
                            "${pregnantInfo['nickname']} 산모님",
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: min(20.sp, 30)),
                          ),
                          InkWell(
                            onTap: () async {
                              final res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MomProfileModify()));
                              if (res == true) {
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "프로필 수정",
                                  style: TextStyle(
                                      color: offButtonTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: min(12.sp, 22)),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 2.w),
                                Image.asset('assets/images/icons/pen.png',
                                    width: min(12.w, 22)),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
                Positioned(
                  top: 303.h,
                  left: paddingValue,
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.w)),
                    margin:
                        EdgeInsets.symmetric(vertical: isTablet ? 30.w : 10.w),
                    color: contentBoxTwoColor,
                    child: SizedBox(
                      width: screenWidth - 2 * paddingValue,
                      height: min(114.w, 144),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "아기와 만나기까지",
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: min(16.sp, 26)),
                              ),
                              Text(' D-${pregnantInfo['dDay']}',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: min(16.sp, 26))),
                            ],
                          ),
                          Container(
                            width: screenWidth - 4 * paddingValue,
                            height: min(12.w, 18),
                            decoration: BoxDecoration(
                              color: lineTwoColor, // 전체 배경색
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: percentage.clamp(0.0, 1.0),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5.w),
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
                  top: 434.h,
                  left: paddingValue,
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.w)),
                    margin:
                        EdgeInsets.symmetric(vertical: isTablet ? 20.w : 10.w),
                    color: contentBoxTwoColor,
                    child: SizedBox(
                      width: screenWidth - 2 * paddingValue,
                      height: min(102.w, 142),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextButton(
                              text: '내 코지로그',
                              textColor: mainTextColor,
                              textWeight: FontWeight.w600,
                              imagePath: 'assets/images/icons/cozylog.png',
                              imageWidth: min(27.3.w, 47.3),
                              imageHeight: min(24.34.w, 44.34),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyCozylog()));
                              }),
                          Container(
                            width: 1.w,
                            height: 42.w,
                            color: const Color(0xffE8E8ED),
                          ),
                          CustomTextButton(
                              text: '스크랩 내역',
                              textColor: mainTextColor,
                              textWeight: FontWeight.w600,
                              imagePath: 'assets/images/icons/scrap.png',
                              imageWidth: min(18.4.w, 38.4),
                              imageHeight: min(24.w, 44),
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
                  top: 552.h,
                  left: paddingValue,
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.w)),
                    margin: EdgeInsets.symmetric(vertical: isTablet? 20.w : 10.w),
                    color: contentBoxTwoColor,
                    child: SizedBox(
                        width: screenWidth - 2 * paddingValue,
                        height: min(222.w, 332),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 45.w - paddingValue, horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 312.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("우리 아이 관리",
                                          style: TextStyle(
                                              color: mainTextColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: min(18.sp, 28))),
                                      Container(
                                        width: min(42.w, 84),
                                        height: 21.w,
                                        decoration: BoxDecoration(
                                          color: contentBoxColor,
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditMode = !isEditMode;
                                            });
                                          },
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsetsGeometry>(
                                                EdgeInsets.zero), // 패딩을 없애는 부분
                                          ),
                                          child: Text(isEditMode ? "완료" : "편집",
                                              style: TextStyle(
                                                  color: offButtonTextColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: min(12.sp, 22))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(top: isTablet? 15.w : 30.w),
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
                                              onTap: () async {
                                                final res =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BabyRegisterScreen(),
                                                  ),
                                                );
                                                if (res == true) {
                                                  setState(() {});
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(horizontal: 10.w),
                                                    child: Image.asset(
                                                      'assets/images/icons/plusDotted.png',
                                                      width: min(82.w, 134),
                                                      height: min(82.w, 134),
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return CustomProfileButton(
                                                text: pregnantInfo['babyProfiles']
                                                        [index]
                                                    .babies
                                                    .map(
                                                        (baby) => baby.babyName)
                                                    .join('/'),
                                                imagePath:
                                                    pregnantInfo['babyProfiles']
                                                            [index]
                                                        .babyProfileImageUrl,
                                                offBackColor:
                                                    const Color(0xffF8F8FA),
                                                onPressed: () async {
                                                  if (!isEditMode) {
                                                    try {
                                                      await userViewModel
                                                          .modifyMainBaby(
                                                              context,
                                                              pregnantInfo[
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
                                                  }
                                                },
                                                isSelected: pregnantInfo['recentBabyProfile'] !=
                                                        null &&
                                                    pregnantInfo['recentBabyProfile']
                                                            .babyProfileId ==
                                                        pregnantInfo['babyProfiles']
                                                                [index]
                                                            .babyProfileId,
                                                isEditMode: isEditMode,
                                                babyProfileId:
                                                    pregnantInfo['babyProfiles']
                                                            [index]
                                                        .babyProfileId,
                                                onProfileUpdated: () {
                                                  setState(() {});
                                                });
                                          }
                                        },
                                      )),
                                ),
                              ],
                            ))),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
