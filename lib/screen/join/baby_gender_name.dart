import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:provider/provider.dart';

class BabyGenderBirthNameScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const BabyGenderBirthNameScreen({super.key, required this.updateValidity});

  @override
  State<BabyGenderBirthNameScreen> createState() =>
      _BabyGenderBirthNameScreenState();
}

class _BabyGenderBirthNameScreenState extends State<BabyGenderBirthNameScreen> {
  final List<String> genderItems = ['남아', '여아', '아직 모르겠어요'];
  List<TextEditingController> birthNameControllers = [];
  List<TextEditingController> genderControllers = [];

  int currentGenderIndex = -1;
  bool isGenderModal = false;
  int babyCount = 1;
  List<bool> isOpenGenderModal = [false];

  @override
  void initState() {
    super.initState();
    final joinInputData = Provider.of<JoinInputData>(context, listen: false);
    if (joinInputData.genders.isNotEmpty &&
        joinInputData.birthNames.isNotEmpty) {
      babyCount = joinInputData.genders.length;
      birthNameControllers = List.generate(
          babyCount,
          (index) =>
              TextEditingController(text: joinInputData.birthNames[index]));
      genderControllers = List.generate(babyCount,
          (index) => TextEditingController(text: joinInputData.genders[index]));
      currentGenderIndex = babyCount - 1;
      // 성별 불러오기 다시 확인 (뒤로가기했다가 돌아왔을때)
    } else {
      addBaby();
    }
  }

  void addBaby() {
    setState(() {
      birthNameControllers.add(TextEditingController());
      genderControllers.add(TextEditingController());
    });
  }

  void _validateFields() {
    bool allFieldsValid = true;
    for (int i = 0; i < birthNameControllers.length; i++) {
      if (birthNameControllers[i].text.isEmpty ||
          genderControllers[i].text.isEmpty) {
        allFieldsValid = false;
        break;
      }
    }
    widget.updateValidity(allFieldsValid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final joinInputData = Provider.of<JoinInputData>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (joinInputData.fetalInfoChanged) {
        _resetData();
        joinInputData.resetFetalInfoChange();
      }
    });
  }

  void _resetData() {
    if (mounted) {
      setState(() {
        babyCount = 1;
        birthNameControllers = [TextEditingController()]; // 새 컨트롤러 초기화
        genderControllers = [TextEditingController()]; // 성별 데이터 초기화
        isOpenGenderModal = [false];
      });
    }
  }

  @override
  void dispose() {
    birthNameControllers.forEach((controller) {
      controller.dispose();
    });
    genderControllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;
    final screenHeight = MediaQuery.of(context).size.height;
    final joinInputData = Provider.of<JoinInputData>(context);
    return SizedBox(
      height: screenHeight - 43.w,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.h, left: paddingValue),
                  child: Text('아기의 정보를 입력해주세요',
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: min(26.sp, 36))),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.h, left: paddingValue, bottom: 30.h),
                  child: Text('정보는 언제든지 마이로그에서 수정할 수 있어요.',
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: min(14.sp, 24))),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= birthNameControllers.length) {
                  birthNameControllers.add(TextEditingController());
                }
                if (index >= genderControllers.length) {
                  genderControllers.add(TextEditingController());
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth - 2 * paddingValue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('태명',
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: min(14.sp, 24))),
                                IconButton(
                                    icon: Image(
                                        image: const AssetImage(
                                            'assets/images/icons/baby_remove.png'),
                                        height: min(15.w, 35),
                                        width: min(14.w, 24)),
                                    onPressed: () {
                                      if (mounted && babyCount > 1) {
                                        print('$index 태아 삭제');
                                        setState(() {
                                          babyCount -= 1;
                                          birthNameControllers.removeAt(index);
                                          genderControllers.removeAt(index);
                                          // 필드 값이 채워졌을때만 joinInputData에서 지워주기(체크 안하면 인덱스 에러 발생)
                                          if (index <
                                              joinInputData.birthNames.length) {
                                            joinInputData.birthNames
                                                .removeAt(index);
                                          }
                                          if (index <
                                              joinInputData.genders.length) {
                                            joinInputData.genders
                                                .removeAt(index);
                                          }
                                          isOpenGenderModal.add(false);
                                        });
                                      }
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.w),
                          Container(
                              width: screenWidth - 2 * paddingValue,
                              height: min(48.w, 78),
                              padding: EdgeInsets.symmetric(
                                  horizontal: min(20.w, 30)),
                              decoration: BoxDecoration(
                                  color: contentBoxTwoColor,
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Center(
                                child: TextFormField(
                                  controller: birthNameControllers[index],
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.start,
                                  maxLength: 10,
                                  cursorColor: primaryColor,
                                  cursorHeight: min(14.sp, 24),
                                  cursorWidth: 1.2.w,
                                  style: TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: min(14.sp, 24)),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 8.w),
                                    border: InputBorder.none,
                                    hintText: '8자 이내로 입력해주세요',
                                    hintStyle: TextStyle(
                                        color: beforeInputColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: min(14.sp, 24)),
                                    counterText: '',
                                  ),
                                  onChanged: (value) {
                                    if (mounted) {
                                      setState(() {
                                        joinInputData.setBirthname(
                                            index, value);
                                        _validateFields();
                                      });
                                    }
                                  },
                                ),
                              )),
                          SizedBox(height: 25.w),
                          Text('성별',
                              style: TextStyle(
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: min(14.sp, 24))),
                          SizedBox(height: 10.w),
                          InkWell(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isOpenGenderModal[index] =
                                      !isOpenGenderModal[index];
                                });
                              }
                            },
                            child: Container(
                              width: screenWidth - 2 * paddingValue,
                              height: min(48.w, 78),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.w)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: min(20.w, 30)),
                              child: IgnorePointer(
                                child: Center(
                                  child: TextFormField(
                                    controller: genderControllers[index],
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 8.w),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                      ),
                                      hintText: '성별',
                                      hintStyle: TextStyle(
                                          color: beforeInputColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: min(14.sp, 24)),
                                      suffixIcon: Icon(
                                          CupertinoIcons.chevron_down,
                                          size: min(15.w, 25),
                                          color: mainTextColor),
                                    ),
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: min(14.sp, 24)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          isOpenGenderModal[index]
                              ? Container(
                                  height: min(188.w, 288),
                                  width: screenWidth - 2 * paddingValue,
                                  margin: EdgeInsets.symmetric(vertical: 8.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w),
                                    color: contentBoxTwoColor,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        genderItems.map<Widget>((String item) {
                                      return InkWell(
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              joinInputData.setGender(
                                                  index, item);
                                              genderControllers[index] =
                                                  (TextEditingController(
                                                      text: item));
                                              _validateFields();
                                              isOpenGenderModal[index] =
                                                  !isOpenGenderModal[index];
                                            });
                                          }
                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              8.w,
                                            ),
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                color: offButtonTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: min(16.sp, 26),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : Container(),
                          babyCount > 1 && index < babyCount - 1
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.w),
                                  width: screenWidth - 2 * paddingValue,
                                  height: 1.w,
                                  color: mainLineColor)
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: babyCount,
            ),
          ),
          SliverToBoxAdapter(
            child: joinInputData.fetalInfo == '다태아'
                ? InkWell(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          babyCount += 1;
                          isOpenGenderModal.add(false);
                        });
                      }
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 20.w),
                        child: Center(
                            child: Text(
                          '+ 태아 추가하기',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(14.sp, 24)),
                        ))))
                : Container(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 60.w),
          )
        ],
      ),
    );
  }
}
