import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  List<String> genders = [];
  int currentGenderIndex = -1;
  bool isGenderModal = false;
  int babyCount = 1;

  @override
  void initState() {
    super.initState();
    addBaby(); // 초기 태아 정보 입력 필드 생성
  }

  void addBaby() {
    setState(() {
      birthNameControllers.add(TextEditingController());
      genders.add('');
    });
  }

  void _validateFields() {
    bool allFieldsValid = true;
    for (int i = 0; i < birthNameControllers.length; i++) {
      if (birthNameControllers[i].text.isEmpty || genders[i].isEmpty) {
        allFieldsValid = false;
        break;
      }
    }
    widget.updateValidity(allFieldsValid);
  }

  @override
  void dispose() {
    birthNameControllers.forEach((controller) {
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
                if (index >= genders.length) {
                  genders.add('');
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
                                    setState(() {
                                      joinInputData.setBirthname(index, value);
                                      _validateFields();
                                    });
                                  },
                                )),
                            const SizedBox(height: 25),
                            const Text('성별',
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: screenWidth - 40,
                              child: DropdownButtonFormField2<String>(
                                // TODO 드롭다운 위치 조정_화면 넘어갈 경우에
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(top: 15),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                hint: const Text(
                                  '성별',
                                  style: TextStyle(
                                      color: beforeInputColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                items: genderItems
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Center(
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                color: offButtonTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  String g = value.toString();
                                  setState(() {
                                    if (g == '남아' || g == '여아') {
                                      g = g.replaceAll('아', '자');
                                    }
                                    genders[currentGenderIndex] = g;
                                    joinInputData.setGender(
                                        currentGenderIndex, g);
                                    _validateFields();
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 48,
                                  width: screenWidth - 40,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: contentBoxTwoColor,
                                  ),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(CupertinoIcons.chevron_down,
                                      size: 15, color: offButtonTextColor),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 188,
                                  width: screenWidth - 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: contentBoxTwoColor,
                                  ),
                                  elevation: 0,
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return genderItems.map<Widget>((String item) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          color: mainTextColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                onMenuStateChange: (isOpen) {
                                  setState(() {
                                    currentGenderIndex = index;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      babyCount > 1 && index < babyCount - 1
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              width: screenWidth - 40,
                              height: 1,
                              color: mainLineColor)
                          : Container(),
                    ],
                  ),
                );
              },
              childCount: babyCount,
            ),
          ),
          SliverToBoxAdapter(
            child: joinInputData.fetalInfo == '다태아'
                ? Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 60),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            babyCount += 1;
                          });
                        },
                        child: const Center(
                            child: Text(
                          '+ 태아 추가하기',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ))))
                : Container(),
          ),
        ],
      ),
    );
  }
}
