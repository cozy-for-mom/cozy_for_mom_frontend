import 'package:cozy_for_mom_frontend/common/extension/map_with_index.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_complite_alert.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/baby/grow_report_register.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_list_screen.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:intl/intl.dart';

class BabyGrowthReportDetailScreen extends StatefulWidget {
  final int babyProfileGrowthId;
  final String? babyProfileImageUrl;
  const BabyGrowthReportDetailScreen(
      {super.key, required this.babyProfileGrowthId, this.babyProfileImageUrl});

  @override
  State<BabyGrowthReportDetailScreen> createState() =>
      _BabyGrowthReportDetailScreenState();
}

class _BabyGrowthReportDetailScreenState
    extends State<BabyGrowthReportDetailScreen> {
  late Future<BabyProfileGrowth> growth;

  late BabyProfileGrowth data;

  Color bottomLineColor = mainLineColor;
  ValueNotifier<BabyGrowth?> selectedBaby = ValueNotifier<BabyGrowth?>(null);
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
    final babyGrowthApiService = BabyGrowthApiService();

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text(
            "성장 보고서",
            style: TextStyle(
              color: mainTextColor,
              fontWeight: FontWeight.w600,
              fontSize: AppUtils.scaleSize(context, 18),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: mainTextColor),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const BabyGrowthReportListScreen()));
            },
          ),
        ),
        body: FutureBuilder(
          future: growth,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data!;
              selectedBaby = ValueNotifier<BabyGrowth?>(
                data.babies![selectedBabyIndex],
              );
              selectedBaby.value = data.babies![selectedBabyIndex];

              return ValueListenableBuilder<BabyGrowth?>(
                  valueListenable: selectedBaby,
                  builder: (context, activeProfile, child) {
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: AppUtils.scaleSize(context, 20),
                                left: AppUtils.scaleSize(context, 10),
                                bottom: AppUtils.scaleSize(context, 32)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: snapshot.data!.babies!
                                  .mapWithIndex((baby, index) {
                                return CustomProfileButton(
                                  text: baby.name,
                                  imagePath: widget.babyProfileImageUrl ?? '',
                                  offBackColor: const Color(0xffF0F0F5),
                                  isSelected: activeProfile == baby,
                                  onPressed: () {
                                    setState(
                                      () {
                                        selectedBabyIndex = index;
                                        selectedBaby.value = baby;
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
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUtils.scaleSize(context, 20)),
                            child: SizedBox(
                              width: screenWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.title,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              AppUtils.scaleSize(context, 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppUtils.scaleSize(context, 5),
                                      ),
                                      Text(
                                        "${DateFormat("yyyy. MM. dd HH:mm").format(data.date)} 작성",
                                        style: TextStyle(
                                          color: const Color(0xffAAAAAA),
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              AppUtils.scaleSize(context, 14),
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
                                            height: AppUtils.scaleSize(
                                                context, 230),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          AppUtils.scaleSize(
                                                              context, 8)),
                                                  width: screenWidth -
                                                      AppUtils.scaleSize(
                                                          context, 40),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                        children: <Widget>[
                                                          ListTile(
                                                            title: const Center(
                                                                child: Text(
                                                              '수정하기',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            )),
                                                            onTap: () {
                                                              Navigator
                                                                  .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          GrowReportRegister(
                                                                    babyProfileGrowth:
                                                                        snapshot
                                                                            .data,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: const Center(
                                                                child: Text(
                                                              '보고서 삭제하기',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            )),
                                                            onTap: () async {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const BabyGrowthReportListScreen()));
                                                              await babyGrowthApiService
                                                                  .deleteBabyProfileGrowth(
                                                                      widget
                                                                          .babyProfileGrowthId);

                                                              setState(() {
                                                                if (mounted) {
                                                                  CompleteAlertModal
                                                                      .showDeleteCompleteDialog(
                                                                          context,
                                                                          '성장 보고서가',
                                                                          '삭제');
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: AppUtils.scaleSize(
                                                      context, 16),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: screenWidth -
                                                        AppUtils.scaleSize(
                                                            context, 40),
                                                    height: AppUtils.scaleSize(
                                                        context, 56),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: const Color(
                                                          0xffC2C4CB),
                                                    ),
                                                    child: const Center(
                                                        child: Text(
                                                      "취소",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUtils.scaleSize(context, 18),
                                vertical: AppUtils.scaleSize(context, 20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: screenWidth,
                                height: AppUtils.scaleSize(context, 216),
                                decoration: const BoxDecoration(
                                  color: offButtonColor,
                                ),
                                child: data.growthImageUrl != null
                                    ? Image.network(
                                        data.growthImageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUtils.scaleSize(context, 21)),
                            child: SizedBox(
                              width: screenWidth,
                              height: _textFieldHeight,
                              child: Text(
                                data.diary,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUtils.scaleSize(context, 20),
                                vertical: AppUtils.scaleSize(context, 10)),
                            child: Container(
                              width: screenWidth,
                              height: 1,
                              color: mainLineColor,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppUtils.scaleSize(context, 20),
                              vertical: AppUtils.scaleSize(context, 15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "체중",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 14),
                                  ),
                                ),
                                SizedBox(
                                    height: AppUtils.scaleSize(context, 14)),
                                Container(
                                  width: screenWidth -
                                      AppUtils.scaleSize(context, 40),
                                  height: AppUtils.scaleSize(context, 48),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 20)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text:
                                            "${selectedBaby.value!.babyGrowthInfo.weight} g"),
                                    style: TextStyle(
                                      color: afterInputColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppUtils.scaleSize(context, 16),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppUtils.scaleSize(context, 20),
                              vertical: AppUtils.scaleSize(context, 15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "머리 직경",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 14),
                                  ),
                                ),
                                SizedBox(
                                    height: AppUtils.scaleSize(context, 14)),
                                Container(
                                  width: screenWidth -
                                      AppUtils.scaleSize(context, 40),
                                  height: AppUtils.scaleSize(context, 48),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 20)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text:
                                            "${selectedBaby.value!.babyGrowthInfo.headCircum} cm"),
                                    style: TextStyle(
                                      color: afterInputColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppUtils.scaleSize(context, 16),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppUtils.scaleSize(context, 20),
                              vertical: AppUtils.scaleSize(context, 15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "머리 둘레",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 14),
                                  ),
                                ),
                                SizedBox(
                                    height: AppUtils.scaleSize(context, 14)),
                                Container(
                                  width: screenWidth -
                                      AppUtils.scaleSize(context, 40),
                                  height: AppUtils.scaleSize(context, 48),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 20)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text:
                                            "${selectedBaby.value!.babyGrowthInfo.headDiameter} cm"),
                                    style: TextStyle(
                                      color: afterInputColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppUtils.scaleSize(context, 16),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppUtils.scaleSize(context, 20),
                              vertical: AppUtils.scaleSize(context, 15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "복부 둘레",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 14),
                                  ),
                                ),
                                SizedBox(
                                    height: AppUtils.scaleSize(context, 14)),
                                Container(
                                  width: screenWidth -
                                      AppUtils.scaleSize(context, 40),
                                  height: AppUtils.scaleSize(context, 48),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 20)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text:
                                            "${selectedBaby.value!.babyGrowthInfo.abdomenCircum} cm"),
                                    style: TextStyle(
                                      color: afterInputColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppUtils.scaleSize(context, 16),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppUtils.scaleSize(context, 20),
                                vertical: AppUtils.scaleSize(context, 15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "허벅지 길이",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 14),
                                  ),
                                ),
                                SizedBox(
                                    height: AppUtils.scaleSize(context, 14)),
                                Container(
                                  width: screenWidth -
                                      AppUtils.scaleSize(context, 40),
                                  height: AppUtils.scaleSize(context, 48),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 20)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text:
                                            "${selectedBaby.value!.babyGrowthInfo.thighLength} cm"),
                                    style: TextStyle(
                                      color: afterInputColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppUtils.scaleSize(context, 16),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child:
                              SizedBox(height: AppUtils.scaleSize(context, 60)),
                        ),
                      ],
                    );
                  });
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
