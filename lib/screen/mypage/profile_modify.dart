import 'package:cozy_for_mom_frontend/screen/mypage/logout_modal.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/user_delete_screen.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/profile_info_form.dart';
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
  bool _isSuffixVisible = false;
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    introduceController = TextEditingController();
    userViewModel = Provider.of<UserApiService>(context, listen: true);

    return FutureBuilder(
      future: userViewModel.getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pregnantInfo = snapshot.data!;
          introduceController.text = pregnantInfo['introduce'];
          Map<String, TextEditingController> controllers = {
            '이름': TextEditingController(text: pregnantInfo['name']),
            '닉네임': TextEditingController(text: pregnantInfo['nickname']),
            '이메일': TextEditingController(text: pregnantInfo['email']),
            '생년월일': TextEditingController(text: pregnantInfo['birth'])
          };
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: backgroundColor,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  backgroundColor: backgroundColor,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 100),
                          const Text('프로필 수정',
                              style: TextStyle(
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  leading: Container(),
                  actions: [
                    InkWell(
                      child: Container(
                        margin: const EdgeInsets.only(right: 20, bottom: 10),
                        alignment: Alignment.center,
                        width: 53,
                        height: 29,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(33),
                        ),
                        child: const Text(
                          '완료',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        print('수정 완료');
                        print(
                            '${controllers['이름']!.text}.${controllers['닉네임']!.text}.${controllers['이메일']!.text}.${controllers['생년월일']!.text}.${introduceController.text}');
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 140,
                    child: Stack(
                      children: [
                        const Positioned(
                          top: 10,
                          left: 145,
                          child: Image(
                              image: AssetImage(
                                  "assets/images/icons/momProfile.png"),
                              width: 100,
                              height: 100),
                        ),
                        Positioned(
                          top: 181 - 109,
                          left: 229,
                          child: InkWell(
                            onTap: () {
                              // 이미지 추가 로직
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
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: screenWidth - 40,
                    height: 96,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "소개",
                          style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        Container(
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
                              counterText: '',
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
                              suffixIcon: introduceController.text.isNotEmpty &&
                                      _isSuffixVisible
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
                            onTap: () {
                              setState(() {
                                _isSuffixVisible = true;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: screenWidth - 40,
                          height: 1,
                          color: mainLineColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      String type = momInfoType[index];
                      String hint = '';
                      if (type == '이름') {
                        hint = '이름을 입력해주세요.';
                        // controllers[type]!.text = pregnantInfo['name'];
                      } else if (type == '닉네임') {
                        hint = '8자 이내로 입력해주세요.';
                        // controllers[type]!.text = pregnantInfo['nickname'];
                      } else if (type == '이메일') {
                        hint = 'cozy@cozy.com';
                        // controllers[type]!.text = pregnantInfo['email'];
                      } else {
                        hint = 'YYYY.MM.DD';
                        // controllers[type]!.text = pregnantInfo['birth'];
                      }
                      return Column(
                        children: [
                          ProfileInfoForm(
                            title: type,
                            hint: hint,
                            controller: controllers[type],
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                    childCount: momInfoType.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: 132,
                    height: 21,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 820,
                          left: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                  print('회원탈퇴 버튼 클릭');
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
      },
    );
  }
}
