import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/info_input_form.dart';

class MomProfileModify extends StatefulWidget {
  const MomProfileModify({super.key});

  @override
  State<MomProfileModify> createState() => _MomProfileModifyState();
}

class _MomProfileModifyState extends State<MomProfileModify> {
  Color cusorColor = beforeInputColor;
  final user = User(1, "쥬쥬", "안소현", "shsh@shsh.com", DateTime(1999, 3, 3));
  final momInfoType = ["이름", "닉네임", "이메일", "생년월일"];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      image: AssetImage("assets/images/icons/momProfile.png"),
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
                    image: AssetImage("assets/images/icons/circle_pen.png"),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              Positioned(
                top: 244.77,
                left: 21,
                child: SizedBox(
                  width: 340, // TODO 화면 너비에 맞춘 width로 수정해야함
                  height: 24,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    cursorColor: cusorColor,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "자기소개를 입력해주세요",
                        hintStyle: TextStyle(
                            color: offButtonTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    onChanged: (text) {
                      setState(() {
                        if (text.isNotEmpty) {
                          cusorColor = afterInputColor;
                        } else {
                          cusorColor = beforeInputColor;
                        }
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                top: 270,
                left: 20,
                child: Container(
                  width: 350,
                  height: 1,
                  color: mainLineColor,
                ),
              ),
              Positioned(
                  top: 305,
                  left: 20,
                  child: Column(
                    children: momInfoType.map((type) {
                      return Column(
                        children: [
                          InfoInputForm(
                              title: type,
                              hint: '-'), // 각 입력 정보에 맞는 hintText 설정해야 함
                          const Padding(padding: EdgeInsets.only(bottom: 20)),
                        ],
                      );
                    }).toList(),
                  )),
              Positioned(
                top: 748.77,
                left: 129,
                child: SizedBox(
                    width: 132,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              print('로그아웃 버튼 클릭'); // 로그아웃 기능 구현
                            },
                            child: const Text('로그아웃',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ),
                          Container(
                            width: 1,
                            height: 11,
                            color: primaryColor,
                          ),
                          InkWell(
                            onTap: () {
                              print('회원탈퇴 버튼 클릭'); // TODO 회원탈퇴 기능 구현
                            },
                            child: const Text('회원탈퇴',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ),
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
