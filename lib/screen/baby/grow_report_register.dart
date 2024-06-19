import 'dart:io';

import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_text_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/info_input_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GrowReportRegister extends StatefulWidget {
  const GrowReportRegister({
    super.key,
  });

  @override
  State<GrowReportRegister> createState() => _GrowReportRegisterState();
}

class _GrowReportRegisterState extends State<GrowReportRegister> {
  List<Baby> babies = List.empty();
  Color bottomLineColor = mainLineColor;
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;
  TextEditingController titleController = TextEditingController();
  TextEditingController diaryController = TextEditingController();
  Map<Baby, List<TextEditingController>> infoControllersByBabies = {};
  late ValueNotifier<Baby?> selectedBaby;
  late List<BabyProfile> profiles;
  double _textFieldHeight = 50.0; // 초기 높이
  File? selectedImage;

  final babyInfoType = ["체중", "머리 직경", "머리 둘레", "복부 둘레", "허벅지 길이"];
  final babyInfoUnit = ["g", "cm", "cm", "cm", "cm"];
  double calculateHeight(String text) {
    return 50.0 + text.length.toDouble() / 1.2;
  }

  @override
  void initState() {
    infoControllersByBabies = {
      for (var e in babies)
        e: List.generate(5, (index) => TextEditingController())
    };
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final babyGrowthApiService = BabyGrowthApiService();
    userViewModel = Provider.of<UserApiService>(context, listen: true);

    bool isRegisterButtonEnabled() {
      return titleController.text.isNotEmpty ||
          diaryController.text.isNotEmpty ||
          infoControllersByBabies.values.any(
              (element) => element.any((element) => element.text.isNotEmpty));
    }

    return FutureBuilder(
        future: userViewModel.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantInfo = snapshot.data!;
            babies = pregnantInfo['recentBabyProfile'].babies;
            selectedBaby = ValueNotifier<Baby?>(babies[0]);
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ));
          }
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                "성장 보고서",
                style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, bottom: 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: babies.map((baby) {
                        return ValueListenableBuilder<Baby?>(
                          valueListenable: selectedBaby,
                          builder: (context, activeProfile, child) {
                            return CustomProfileButton(
                              text: baby.babyName,
                              imagePath:
                                  pregnantInfo['babyProfileImageUrl'] ?? '',
                              offBackColor: const Color(0xffF0F0F5),
                              isSelected: activeProfile == baby,
                              onPressed: () {
                                setState(() {
                                  selectedBaby.value = baby;
                                });
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
                        controller: titleController,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        cursorColor: primaryColor,
                        cursorHeight: 21,
                        cursorWidth: 1.5,
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
                              bottomLineColor = primaryColor;
                            } else {
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
                      height: 1.5,
                      color: bottomLineColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 20),
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
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return SelectBottomModal(
                                  selec1: '직접 찍기',
                                  selec2: '앨범에서 선택',
                                  tap1: () {
                                    print('카메라 구현'); // TODO 카메라 연동 구현
                                  },
                                  tap2: _pickImage);
                            },
                          );
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
                      height: _textFieldHeight,
                      child: TextFormField(
                        controller: diaryController,
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        cursorColor: primaryColor,
                        cursorHeight: 17,
                        cursorWidth: 1.5,
                        decoration: const InputDecoration(
                          isDense: true,
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
                            // 텍스트의 길이에 따라 높이를 조절
                            _textFieldHeight = calculateHeight(text);
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
                      final control =
                          infoControllersByBabies[selectedBaby.value]?[index];
                      return ValueListenableBuilder<Baby?>(
                        valueListenable: selectedBaby,
                        builder: (context, activeProfile, child) {
                          return Column(children: [
                            const Padding(padding: EdgeInsets.only(bottom: 30)),
                            InfoInputForm(
                              title: type,
                              hint: "0 $unit",
                              suffix: unit,
                              controller: control,
                              onChanged: () {
                                setState(() {});
                              },
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 26),
                    child: InkWell(
                      onTap: () {
                        babyGrowthApiService
                            .createBabyProfileGrowth(BabyProfileGrowth(
                          id: null,
                          date: DateTime.now(),
                          growthImageUrl: "growthImageUrl",
                          diary: diaryController.text,
                          title: titleController.text,
                          babies: babies
                              .map(
                                (baby) => BabyGrowth(
                                  id: null,
                                  name: "dd",
                                  babyId: baby.babyId,
                                  babyGrowthInfo: BabyGrowthInfo(
                                    weight: parseDouble(
                                        infoControllersByBabies[baby]?[0]
                                                .text ??
                                            '0'),
                                    headDiameter: parseDouble(
                                        infoControllersByBabies[baby]?[1]
                                                .text ??
                                            '0'),
                                    headCircum: parseDouble(
                                        infoControllersByBabies[baby]?[2]
                                                .text ??
                                            '0'),
                                    abdomenCircum: parseDouble(
                                        infoControllersByBabies[baby]?[3]
                                                .text ??
                                            '0'),
                                    thighLength: parseDouble(
                                        infoControllersByBabies[baby]?[4]
                                                .text ??
                                            '0'),
                                  ),
                                ),
                              )
                              .toList(),
                        ));
                      },
                      child: Container(
                        width: screenWidth,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: isRegisterButtonEnabled()
                                ? primaryColor
                                : const Color(0xffC9DFF9),
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
        });
  }
}

// class Baby {
//   final int id;
//   final String name;
//   final String image;
//   bool isProfileSelected = false; // 프로필 선택 상태를 저장

//   Baby(
//       {required this.id,
//       required this.name,
//       required this.image,
//       this.isProfileSelected = false});
// }

double parseDouble(String value, {double defaultValue = 0.0}) {
  try {
    return double.parse(value);
  } catch (e) {
    return defaultValue;
  }
}
