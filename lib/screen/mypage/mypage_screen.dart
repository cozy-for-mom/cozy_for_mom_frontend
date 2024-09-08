import 'package:cozy_for_mom_frontend/screen/mypage/baby_register_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_scrap.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image(
                    width: screenWidth - AppUtils.scaleSize(context, 40),
                    fit: BoxFit.cover,
                    image: const AssetImage(
                      "assets/images/subtract.png",
                    ),
                  ),
                ),
                Positioned(
                  top: AppUtils.scaleSize(context, 47),
                  left: AppUtils.scaleSize(context, 340),
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: AppUtils.scaleSize(context, 28),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                ),
                Positioned(
                  top: AppUtils.scaleSize(context, 119),
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: AppUtils.scaleSize(context, 161),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          pregnantInfo['imageUrl'] == null
                              ? Image.asset(
                                  'assets/images/icons/momProfile.png',
                                  fit: BoxFit.cover, // 이미지를 화면에 맞게 조절
                                  width: AppUtils.scaleSize(context, 100),
                                  height: AppUtils.scaleSize(context, 100),
                                  alignment: Alignment.center,
                                )
                              : ClipOval(
                                  child: Image.network(
                                    pregnantInfo['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: AppUtils.scaleSize(context, 100),
                                    height: AppUtils.scaleSize(context, 100),
                                  ),
                                ),
                          SizedBox(height: AppUtils.scaleSize(context, 8)),
                          Text(
                            "${pregnantInfo['nickname']} 산모님",
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: AppUtils.scaleSize(context, 20)),
                          ),
                          SizedBox(height: AppUtils.scaleSize(context, 4)),
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
                                      fontSize:
                                          AppUtils.scaleSize(context, 12)),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: AppUtils.scaleSize(context, 2)),
                                Image.asset('assets/images/icons/pen.png',
                                    width: AppUtils.scaleSize(context, 12)),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
                Positioned(
                  top: AppUtils.scaleSize(context, 303),
                  left: AppUtils.scaleSize(context, 11),
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    margin: EdgeInsets.all(AppUtils.scaleSize(context, 10)),
                    color: contentBoxTwoColor,
                    child: SizedBox(
                      width: screenWidth - AppUtils.scaleSize(context, 40),
                      height: AppUtils.scaleSize(context, 114),
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
                                    fontSize: AppUtils.scaleSize(context, 16)),
                              ),
                              Text(' D-${pregnantInfo['dDay']}',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          AppUtils.scaleSize(context, 16))),
                            ],
                          ),
                          Container(
                            width:
                                screenWidth - AppUtils.scaleSize(context, 80),
                            height: AppUtils.scaleSize(context, 12),
                            decoration: BoxDecoration(
                              color: lineTwoColor, // 전체 배경색
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: percentage,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: AppUtils.scaleSize(context, 20),
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
                  top: AppUtils.scaleSize(context, 434),
                  left: AppUtils.scaleSize(context, 10),
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    margin: EdgeInsets.all(AppUtils.scaleSize(context, 10)),
                    color: contentBoxTwoColor,
                    child: SizedBox(
                      width: screenWidth - AppUtils.scaleSize(context, 40),
                      height: AppUtils.scaleSize(context, 102),
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
                            height: AppUtils.scaleSize(context, 42),
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
                  top: AppUtils.scaleSize(context, 552),
                  left: AppUtils.scaleSize(context, 10),
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    margin: EdgeInsets.all(AppUtils.scaleSize(context, 10)),
                    color: contentBoxTwoColor,
                    child: SizedBox(
                        width: screenWidth - AppUtils.scaleSize(context, 40),
                        height: AppUtils.scaleSize(context, 222),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppUtils.scaleSize(context, 25),
                                horizontal: AppUtils.scaleSize(context, 20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: AppUtils.scaleSize(context, 312),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("우리 아이 관리",
                                          style: TextStyle(
                                              color: mainTextColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: AppUtils.scaleSize(
                                                  context, 18))),
                                      Container(
                                        width: AppUtils.scaleSize(context, 42),
                                        height: AppUtils.scaleSize(context, 21),
                                        decoration: BoxDecoration(
                                          color: contentBoxColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                  fontSize: AppUtils.scaleSize(
                                                      context, 12))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: AppUtils.scaleSize(context, 30)),
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
                                                        EdgeInsets.fromLTRB(
                                                            AppUtils.scaleSize(
                                                                context, 10),
                                                            0,
                                                            AppUtils.scaleSize(
                                                                context, 10),
                                                            AppUtils.scaleSize(
                                                                context, 10)),
                                                    child: Image.asset(
                                                      'assets/images/icons/plusDotted.png',
                                                      width: AppUtils.scaleSize(
                                                          context, 82),
                                                      height:
                                                          AppUtils.scaleSize(
                                                              context, 82),
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
