import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/baby_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_text_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/info_input_form.dart';

ValueNotifier<BabyProfile?> selectedProfile = ValueNotifier<BabyProfile?>(null);

class GrowReportRegister extends StatefulWidget {
  const GrowReportRegister({super.key});

  @override
  State<GrowReportRegister> createState() => _GrowReportRegisterState();
}

class _GrowReportRegisterState extends State<GrowReportRegister> {
  Color cusorColor = beforeInputColor; // TODO 커서
  Color bottomLineColor = mainLineColor;
  List<BabyProfile> profiles = [
    BabyProfile(
        babyId: 1,
        name: "미룽이",
        image:
            'assets/images/icons/babyProfileOn.png'), // TODO 태아 기본 프로필 이미지 on/off 논의 후 수정
    BabyProfile(
        babyId: 2, name: "행운이", image: 'assets/images/icons/babyProfileOff.png')
  ];
  final babyInfoType = ["체중", "머리 직경", "머리 둘레", "복부 둘레", "허벅지 길이"];
  final babyInfoUnit = ["g", "cm", "cm", "cm", "cm"];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text(
              '성장 보고서',
              style: TextStyle(
                color: mainTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, bottom: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: profiles.map((profile) {
                  return ValueListenableBuilder<BabyProfile?>(
                    valueListenable: selectedProfile,
                    builder: (context, activeProfile, child) {
                      return CustomProfileButton(
                        text: profile.name,
                        imagePath: profile.image,
                        offBackColor: const Color(0xffF0F0F5),
                        isSelected: activeProfile == profile,
                        onPressed: () {
                          selectedProfile.value = profile;
                          print(
                              'id:${profile.babyId} ${profile.name} 버튼이 클릭되었습니다.'); // TODO 다둥이일 경우 성장보고서 컴포넌트 전환
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: screenWidth,
                height: 52,
                child: TextFormField(
                  // TODO 제목 글자 수 제한
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  cursorColor: cusorColor, // TODO 커서 나타낼지 말지 논의 후 수정
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "제목을 입력해주세요",
                    hintStyle: TextStyle(
                      color: offButtonTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      if (text.isNotEmpty) {
                        cusorColor = Colors.transparent; // TODO 커서
                        bottomLineColor = primaryColor;
                      } else {
                        cusorColor = beforeInputColor;
                        bottomLineColor = mainLineColor;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: screenWidth,
                height: 1,
                color: bottomLineColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Container(
                width: screenWidth,
                height: 216,
                decoration: BoxDecoration(
                  color: offButtonColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomTextButton(
                  text: '사진을 등록해보세요!',
                  textColor: const Color(0xff9397A4),
                  textWeight: FontWeight.w500,
                  imagePath: 'assets/images/icons/photo_register.png',
                  imageWidth: 45.6,
                  imageHeight: 36.9,
                  onPressed: () {
                    print('사진등록 버튼 클릭됨'); // TODO 사진 등록 및 불러오기 구현
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SizedBox(
                width: screenWidth,
                height: 56,
                child: TextFormField(
                  // TODO 내용 글자 수 제한
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  cursorColor: cusorColor, // TODO 커서 나타낼지 말지 논의 후 수정
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "내용을 입력하세요.",
                    hintStyle: TextStyle(
                      color: offButtonTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      if (text.isNotEmpty) {
                        cusorColor = Colors.transparent; // TODO 커서
                      } else {
                        cusorColor = beforeInputColor;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: screenWidth,
                height: 1,
                color: mainLineColor,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final type = babyInfoType[index];
                final unit = babyInfoUnit[index];
                return ValueListenableBuilder<BabyProfile?>(
                  valueListenable: selectedProfile,
                  builder: (context, activeProfile, child) {
                    return Column(children: [
                      const Padding(padding: EdgeInsets.only(bottom: 30)),
                      InfoInputForm(
                        title: type,
                        hint: "0 $unit",
                        suffix: unit,
                      ),
                    ]);
                  },
                );
              },
              childCount: babyInfoType.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              child: InkWell(
                onTap: () {
                  print("등록 버튼 클릭"); // TODO 등록 버튼 클릭 시 실행문 구현
                },
                child: Container(
                  width: screenWidth,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0xffC9DFF9),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text("등록하기",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
        ],
      ),
    );
  }
}
