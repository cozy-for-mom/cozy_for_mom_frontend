import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final joinInputData = Provider.of<JoinInputData>(context);
    return SizedBox(
      height: screenHeight - AppUtils.scaleSize(context, 43),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: AppUtils.scaleSize(context, 50),
                      left: AppUtils.scaleSize(context, 20)),
                  child: Text('아기의 정보를 입력해주세요',
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: AppUtils.scaleSize(context, 26))),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: AppUtils.scaleSize(context, 10),
                      left: AppUtils.scaleSize(context, 20),
                      bottom: AppUtils.scaleSize(context, 30)),
                  child: Text('정보는 언제든지 마이로그에서 수정할 수 있어요.',
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scaleSize(context, 14))),
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
                  padding:
                      EdgeInsets.only(left: AppUtils.scaleSize(context, 20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: AppUtils.scaleSize(context, 10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width:
                                  screenWidth - AppUtils.scaleSize(context, 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('태명',
                                      style: TextStyle(
                                          color: mainTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              AppUtils.scaleSize(context, 14))),
                                  IconButton(
                                      icon: Image(
                                          image: const AssetImage(
                                              'assets/images/icons/baby_remove.png'),
                                          height:
                                              AppUtils.scaleSize(context, 15),
                                          width:
                                              AppUtils.scaleSize(context, 14)),
                                      onPressed: () {
                                        print('$index 태아 삭제');
                                        if (mounted && babyCount > 1) {
                                          setState(() {
                                            babyCount -= 1;
                                            birthNameControllers
                                                .removeAt(index);
                                            genderControllers.removeAt(index);
                                            joinInputData.birthNames
                                                .removeAt(index);
                                            joinInputData.genders
                                                .removeAt(index);
                                            isOpenGenderModal.add(false);
                                          });
                                        }
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(height: AppUtils.scaleSize(context, 10)),
                            Container(
                                width: screenWidth -
                                    AppUtils.scaleSize(context, 40),
                                height: AppUtils.scaleSize(context, 48),
                                padding: EdgeInsets.symmetric(
                                    vertical: AppUtils.scaleSize(context, 10),
                                    horizontal:
                                        AppUtils.scaleSize(context, 20)),
                                decoration: BoxDecoration(
                                    color: contentBoxTwoColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: birthNameControllers[index],
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLength: 10,
                                  cursorColor: primaryColor,
                                  cursorHeight: AppUtils.scaleSize(context, 14),
                                  cursorWidth: AppUtils.scaleSize(context, 1.2),
                                  style: TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          AppUtils.scaleSize(context, 14)),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical:
                                            AppUtils.scaleSize(context, 10)),
                                    border: InputBorder.none,
                                    hintText: '8자 이내로 입력해주세요',
                                    hintStyle: TextStyle(
                                        color: beforeInputColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            AppUtils.scaleSize(context, 14)),
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
                                )),
                            SizedBox(height: AppUtils.scaleSize(context, 25)),
                            Text('성별',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 14))),
                            SizedBox(height: AppUtils.scaleSize(context, 10)),
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
                                width: screenWidth -
                                    AppUtils.scaleSize(context, 40),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(
                                    left: AppUtils.scaleSize(context, 20)),
                                child: IgnorePointer(
                                  child: TextFormField(
                                    controller: genderControllers[index],
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: AppUtils.scaleSize(context, 15)),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: '성별',
                                      hintStyle: TextStyle(
                                          color: beforeInputColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              AppUtils.scaleSize(context, 14)),
                                      suffixIcon: const Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 15,
                                          color: mainTextColor),
                                    ),
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            AppUtils.scaleSize(context, 14)),
                                  ),
                                ),
                              ),
                            ),
                            isOpenGenderModal[index]
                                ? Container(
                                    height: AppUtils.scaleSize(context, 188),
                                    width: screenWidth -
                                        AppUtils.scaleSize(context, 40),
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            AppUtils.scaleSize(context, 8)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: contentBoxTwoColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: genderItems
                                          .map<Widget>((String item) {
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
                                                  AppUtils.scaleSize(
                                                      context, 8)),
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  color: offButtonTextColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: AppUtils.scaleSize(
                                                      context, 16),
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
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            AppUtils.scaleSize(context, 30)),
                                    width: screenWidth -
                                        AppUtils.scaleSize(context, 40),
                                    height: 1,
                                    color: mainLineColor)
                                : Container(),
                          ],
                        ),
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
                        padding: EdgeInsets.only(
                            top: AppUtils.scaleSize(context, 10)),
                        child: Center(
                            child: Text(
                          '+ 태아 추가하기',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppUtils.scaleSize(context, 14)),
                        ))))
                : Container(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: AppUtils.scaleSize(context, 100)),
          )
        ],
      ),
    );
  }
}
