import 'package:cozy_for_mom_frontend/common/extension/map_with_index.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/baby/grow_report_register.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:intl/intl.dart';

class BabyGrowthReportDetailScreen extends StatefulWidget {
  final int babyProfileGrowthId;
  const BabyGrowthReportDetailScreen({
    super.key,
    required this.babyProfileGrowthId,
  });

  @override
  State<BabyGrowthReportDetailScreen> createState() =>
      _BabyGrowthReportDetailScreenState();
}

class _BabyGrowthReportDetailScreenState
    extends State<BabyGrowthReportDetailScreen> {
  late Future<BabyProfileGrowth> growth;

  Color bottomLineColor = mainLineColor;
  late ValueNotifier<BabyGrowth?> selectedBaby;
  var selectedBabyIndex = 0;
  final double _textFieldHeight = 50.0; // 초기 높이

  final babyInfoType = ["체중", "머리 직경", "머리 둘레", "복부 둘레", "허벅지 길이"];
  final babyInfoUnit = ["g", "cm", "cm", "cm", "cm"];
  double calculateHeight(String text) {
    return 50.0 + text.length.toDouble() / 1.2;
  }

  @override
  void initState() {
    super.initState();
    growth =
        BabyGrowthApiService().getBabyProfileGrowth(widget.babyProfileGrowthId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
        body: FutureBuilder(
          future: growth,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              selectedBaby = ValueNotifier<BabyGrowth?>(
                snapshot.data!.babies![selectedBabyIndex],
              );
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, bottom: 32),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            snapshot.data!.babies!.mapWithIndex((baby, index) {
                          return ValueListenableBuilder<BabyGrowth?>(
                            valueListenable: selectedBaby,
                            builder: (context, activeProfile, child) {
                              return CustomProfileButton(
                                text: baby.name,
                                imagePath:
                                    'assets/images/icons/babyProfileOn.png', // TODO 수정
                                offBackColor: const Color(0xffF0F0F5),
                                isSelected: activeProfile == baby,
                                onPressed: () {
                                  setState(() {
                                    selectedBabyIndex = index;
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${DateFormat("yyyy. MM. dd HH:mm").format(snapshot.data!.date)} 작성",
                                  style: const TextStyle(
                                    color: Color(0xffAAAAAA),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 220,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 350,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Column(children: <Widget>[
                                                ListTile(
                                                  title: const Center(
                                                      child: Text(
                                                    '수정하기',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                                  onTap: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const GrowReportRegister(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                ListTile(
                                                  title: const Center(
                                                      child: Text(
                                                    '삭제하기',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                                  onTap: () {
                                                    // TODO 삭제하기 API 호출
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 350,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(0xffC2C4CB),
                                              ),
                                              child: const Center(
                                                  child: Text(
                                                "취소",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert_outlined,
                                color: Color(0xff858998),
                              ),
                            )
                          ],
                        ),
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
                        child: Image.network(
                          snapshot.data!.growthImageUrl,
                          fit: BoxFit.cover,
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
                        child: Text(
                          snapshot.data!.diary,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "체중",
                            style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 350,
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              initialValue:
                                  "${snapshot.data!.babies![0].babyGrowthInfo.weight} g",
                              cursorColor: primaryColor,
                              cursorHeight: 17,
                              cursorWidth: 1.5,
                              style: const TextStyle(
                                color: afterInputColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "머리 직경",
                            style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 350,
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              initialValue:
                                  "${snapshot.data!.babies![selectedBabyIndex].babyGrowthInfo.headCircum} cm",
                              cursorColor: primaryColor,
                              cursorHeight: 17,
                              cursorWidth: 1.5,
                              style: const TextStyle(
                                color: afterInputColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "머리 둘레",
                            style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 350,
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              initialValue:
                                  "${snapshot.data!.babies![selectedBabyIndex].babyGrowthInfo.headDiameter} cm",
                              cursorColor: primaryColor,
                              cursorHeight: 17,
                              cursorWidth: 1.5,
                              style: const TextStyle(
                                color: afterInputColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "복부 둘레",
                            style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 350,
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              initialValue:
                                  "${snapshot.data!.babies![selectedBabyIndex].babyGrowthInfo.abdomenCircum} cm",
                              cursorColor: primaryColor,
                              cursorHeight: 17,
                              cursorWidth: 1.5,
                              style: const TextStyle(
                                color: afterInputColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "허벅지 길이",
                            style: TextStyle(
                              color: offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 350,
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              initialValue:
                                  "${snapshot.data!.babies![selectedBabyIndex].babyGrowthInfo.thighLength} cm",
                              cursorColor: primaryColor,
                              cursorHeight: 17,
                              cursorWidth: 1.5,
                              style: const TextStyle(
                                color: afterInputColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ));
  }
}

class Baby {
  final int id;
  final String name;
  final String image;
  bool isProfileSelected = false; // 프로필 선택 상태를 저장

  Baby(
      {required this.id,
      required this.name,
      required this.image,
      this.isProfileSelected = false});
}

double parseDouble(String value, {double defaultValue = 0.0}) {
  try {
    return double.parse(value);
  } catch (e) {
    return defaultValue;
  }
}
