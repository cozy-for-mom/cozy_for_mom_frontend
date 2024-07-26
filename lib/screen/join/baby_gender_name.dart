import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:provider/provider.dart';

class BabyGenderScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const BabyGenderScreen({super.key, required this.updateValidity});

  @override
  State<BabyGenderScreen> createState() => _BabyGenderScreenState();
}

class _BabyGenderScreenState extends State<BabyGenderScreen> {
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
      height: screenHeight - 43,
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20),
                  child: Text('아기의 정보를 입력해주세요',
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 26)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, bottom: 30),
                  child: Text('정보는 언제든지 마이로그에서 수정할 수 있어요.',
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('태명',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            const SizedBox(height: 10),
                            Container(
                                width: screenWidth - 40,
                                height: 48,
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 20),
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
                                  cursorHeight: 14,
                                  cursorWidth: 1.2,
                                  style: const TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    border: InputBorder.none,
                                    hintText: '8자 이내로 입력해주세요',
                                    hintStyle: TextStyle(
                                        color: beforeInputColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
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
                            const SizedBox(height: 25),
                            const Text('성별',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            const SizedBox(height: 10),
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
                                width: screenWidth - 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(left: 20),
                                child: IgnorePointer(
                                  child: TextFormField(
                                    controller: genderControllers[index],
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(top: 15),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: '성별',
                                      hintStyle: const TextStyle(
                                          color: beforeInputColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                      suffixIcon: const Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 15,
                                          color: mainTextColor),
                                    ),
                                    style: const TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            isOpenGenderModal[index]
                                ? Container(
                                    height: 188,
                                    width: screenWidth - 40,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  color: offButtonTextColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    width: screenWidth - 40,
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
                    child: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text(
                          '+ 태아 추가하기',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ))))
                : Container(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          )
        ],
      ),
    );
  }
}
