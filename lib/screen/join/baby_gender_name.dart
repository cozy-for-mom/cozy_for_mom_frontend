import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:provider/provider.dart';

class BabyGenderScreen extends StatefulWidget {
  const BabyGenderScreen({super.key});

  @override
  State<BabyGenderScreen> createState() => _BabyGenderScreenState();
}

class _BabyGenderScreenState extends State<BabyGenderScreen> {
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
    final joinInputData = Provider.of<JoinInputData>(context);

    final List<String> info = ['남아', '여아', '아직 모르겠어요'];
    return CustomScrollView(
      slivers: <Widget>[
        const SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 90, left: 20),
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
                                keyboardType: TextInputType.datetime,
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
                          Container(
                            width: screenWidth - 40,
                            height: 48,
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: contentBoxTwoColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              width: screenWidth - 60,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    genders[index].isEmpty
                                        ? const Text('성별',
                                            style: TextStyle(
                                                color: beforeInputColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14))
                                        : Text(genders[index],
                                            style: const TextStyle(
                                                color: mainTextColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                    SizedBox(
                                      width: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              currentGenderIndex = index;
                                              isGenderModal = !isGenderModal;
                                            });
                                          },
                                          icon: const Icon(
                                              CupertinoIcons.chevron_down,
                                              size: 15,
                                              color: offButtonTextColor)),
                                    ),
                                  ]),
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
          child: isGenderModal
              ? Container(
                  width: screenWidth - 40,
                  height: 188,
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 25, left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: contentBoxTwoColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: info
                        .map((g) => InkWell(
                              onTap: () {
                                setState(() {
                                  genders[currentGenderIndex] = g;
                                  joinInputData.setGender(
                                      currentGenderIndex, g);
                                  isGenderModal = !isGenderModal;
                                });
                              },
                              child: Text(g,
                                  style: const TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  )),
                            ))
                        .toList(),
                  ),
                )
              : Container(),
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
    );
  }
}
