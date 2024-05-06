import 'package:cozy_for_mom_frontend/screen/mypage/logout_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/user_delete_screen.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/info_input_form.dart';
import 'package:provider/provider.dart';

class MomProfileModify extends StatefulWidget {
  const MomProfileModify({super.key});

  @override
  State<MomProfileModify> createState() => _MomProfileModifyState();
}

class _MomProfileModifyState extends State<MomProfileModify> {
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;
  late TextEditingController introduceController;
  final momInfoType = ["이름", "닉네임", "이메일", "생년월일"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    introduceController = TextEditingController();
    userViewModel = Provider.of<UserApiService>(context, listen: true);

    return FutureBuilder(
        // TODO 캘린더 연동 (선택한 날짜로 API 요청하도록 수정)
        future: userViewModel.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantInfo = snapshot.data!;
            introduceController.text = pregnantInfo['introduce'];

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: backgroundColor,
              body: SingleChildScrollView(
                child: SizedBox(
                  height: screenHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 47,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const SizedBox(
                                    width: 110), // TODO 화면 너비에 맞춘 width로 수정해야함
                                const Text('프로필 수정',
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                              ],
                            )),
                      ),
                      const Positioned(
                          top: 119,
                          left: 145,
                          child: Image(
                              image: AssetImage(
                                  "assets/images/icons/momProfile.png"),
                              width: 100,
                              height: 100)),
                      Positioned(
                        top: 181,
                        left: 229,
                        child: InkWell(
                          onTap: () {
                            // TODO 이미지 추가 로직
                            print('이미지 수정 버튼 클릭');
                          },
                          child: const Image(
                            image: AssetImage(
                                "assets/images/icons/circle_pen.png"),
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 245,
                          left: 21,
                          child: SizedBox(
                            width: screenWidth - 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text("소개",
                                    style: TextStyle(
                                        color: offButtonTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                                SizedBox(
                                  width: screenWidth - 40,
                                  child: TextFormField(
                                    controller: introduceController,
                                    textAlign: TextAlign.start,
                                    cursorColor: primaryColor,
                                    cursorHeight: 17,
                                    cursorWidth: 1.5,
                                    maxLength: 30,
                                    style: const TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                    decoration: InputDecoration(
                                      counterStyle: const TextStyle(
                                          color: offButtonTextColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                      border: InputBorder.none,
                                      hintText: "자기소개를 입력해주세요",
                                      hintStyle: const TextStyle(
                                          color: beforeInputColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                      suffixIcon:
                                          introduceController.text.isNotEmpty
                                              ? IconButton(
                                                  icon: Image.asset(
                                                    'assets/images/icons/text_delete.png',
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  onPressed: () {
                                                    introduceController.clear();
                                                  },
                                                )
                                              : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                        top: 245 + 67.47,
                        left: 20,
                        child: Container(
                          width: screenWidth - 40,
                          height: 1,
                          color: mainLineColor,
                        ),
                      ),
                      Positioned(
                          top: 359.47,
                          left: 20,
                          child: Column(
                            children: momInfoType.map((type) {
                              String hint = '';
                              TextEditingController textController =
                                  TextEditingController();
                              if (type == '이름') {
                                hint = '이름을 입력해주세요.';
                                textController.text = pregnantInfo['name'];
                              } else if (type == '닉네임') {
                                hint = '8자 이내로 입력해주세요.';
                                textController.text = pregnantInfo['nickname'];
                              } else if (type == '이메일') {
                                hint = 'cozy@cozy.com';
                                textController.text = pregnantInfo['email'];
                              } else {
                                hint = 'YYYY.MM.DD';
                                textController.text = pregnantInfo['birth'];
                              }
                              return Column(
                                children: [
                                  InfoInputForm(
                                    title: type,
                                    hint: hint,
                                    controller: textController,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 20)),
                                ],
                              );
                            }).toList(),
                          )),
                      Positioned(
                        top: 780,
                        left: 129,
                        child: SizedBox(
                          width: 132,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext buildContext) {
                                      return const LogoutModal();
                                    },
                                  );
                                },
                                child: const Text(
                                  '로그아웃',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 11,
                                color: primaryColor,
                              ),
                              InkWell(
                                onTap: () {
                                  print('회원탈퇴 버튼 클릭'); // TODO 회원탈퇴 기능 구현
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserDeleteScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  '회원탈퇴',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent, // 로딩화면(circle)
            ));
          }
        });
  }
}
