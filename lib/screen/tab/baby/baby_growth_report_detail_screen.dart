import 'dart:math';

import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/baby/grow_report_register.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:cozy_for_mom_frontend/service/user/user_local_storage_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/custom_profile_button.dart';
import 'package:intl/intl.dart';

class BabyGrowthReportDetailScreen extends StatefulWidget {
  final int babyProfileGrowthId;
  const BabyGrowthReportDetailScreen(
      {super.key, required this.babyProfileGrowthId});

  @override
  State<BabyGrowthReportDetailScreen> createState() =>
      _BabyGrowthReportDetailScreenState();
}

class _BabyGrowthReportDetailScreenState
    extends State<BabyGrowthReportDetailScreen> {
  late UserLocalStorageService userLocalStorageService;
  late String? babyProfileImageUrl;
  late Future<BabyProfileGrowth?> growth;

  late BabyProfileGrowth data;

  Color bottomLineColor = mainLineColor;
  ValueNotifier<BabyGrowth?> selectedBaby = ValueNotifier<BabyGrowth?>(null);
  var selectedBabyIndex = 0;

  final babyInfoType = ["체중", "머리 직경", "머리 둘레", "복부 둘레", "허벅지 길이"];
  final babyInfoUnit = ["g", "cm", "cm", "cm", "cm"];

  Future<void> initializeBabyInfo() async {
    userLocalStorageService = await UserLocalStorageService.getInstance();
    babyProfileImageUrl =
        await userLocalStorageService.getBabyProfileImageUrl();
  }

  @override
  void initState() {
    super.initState();
    initializeBabyInfo();
    growth = BabyGrowthApiService()
        .getBabyProfileGrowth(context, widget.babyProfileGrowthId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
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
              fontSize: min(18.sp, 28),
            ),
          ),
          leading: IconButton(
            icon: Image(
              image: const AssetImage('assets/images/icons/back_ios.png'),
              width: min(34.w, 44),
              height: min(34.w, 44),
              color: mainTextColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
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
                                top: 20.w, left: 10.w, bottom: 32.w),
                            child: SizedBox(
                              height: 111.w,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.babies!.length,
                                itemBuilder: (context, index) {
                                  var baby = snapshot.data!.babies![index];
                                  return CustomProfileButton(
                                    text: baby.name,
                                    imagePath: babyProfileImageUrl ?? '',
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
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: paddingValue),
                            child: SizedBox(
                              width: screenWidth - 2 * paddingValue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: screenWidth - 4 * paddingValue,
                                    child: Text(
                                      data.title,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(20.sp, 30),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${DateFormat("yyyy. MM. dd HH:mm").format(data.date)} 작성",
                                        style: TextStyle(
                                            color: const Color(0xffAAAAAA),
                                            fontWeight: FontWeight.w500,
                                            fontSize: min(14.sp, 24)),
                                      ),
                                      SizedBox(
                                        width: min(15.w, 25),
                                        height: min(32.w, 42),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0.0,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  width: screenWidth -
                                                      2 * paddingValue,
                                                  height: isTablet
                                                      ? 234.w - paddingValue
                                                      : 234.w,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8.h),
                                                        height: 153.w -
                                                            paddingValue,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.w),
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <Widget>[
                                                                ListTile(
                                                                  title: Center(
                                                                      child:
                                                                          Text(
                                                                    '수정하기',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          mainTextColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: min(
                                                                          16.sp,
                                                                          26),
                                                                    ),
                                                                  )),
                                                                  onTap:
                                                                      () async {
                                                                    await Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                GrowReportRegister(
                                                                          babyProfileGrowth:
                                                                              snapshot.data,
                                                                        ),
                                                                      ),
                                                                    ).then(
                                                                        (value) {
                                                                      if (value ==
                                                                          true) {
                                                                        Navigator.pop(
                                                                            context,
                                                                            true);
                                                                        Navigator.pop(
                                                                            context,
                                                                            true);
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  title: Center(
                                                                      child:
                                                                          Text(
                                                                    '보고서 삭제하기',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          mainTextColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: min(
                                                                          16.sp,
                                                                          26),
                                                                    ),
                                                                  )),
                                                                  onTap:
                                                                      () async {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return DeleteModal(
                                                                          title:
                                                                              '성장 보고서가',
                                                                          text:
                                                                              '등록된 성장 보고서를 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                                          tapFunc:
                                                                              () async {
                                                                            await babyGrowthApiService.deleteBabyProfileGrowth(context,
                                                                                widget.babyProfileGrowthId);
                                                                            setState(() {});
                                                                          },
                                                                          shouldCloseParentCnt:
                                                                              3,
                                                                        );
                                                                      },
                                                                      barrierDismissible:
                                                                          false,
                                                                    );
                                                                  },
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.w,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          height: min(56.w, 96),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.w),
                                                            color: const Color(
                                                                0xffC2C4CB),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            "취소",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: min(
                                                                  16.sp, 26),
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
                                          icon: Image(
                                            image: const AssetImage(
                                                'assets/images/icons/more_vert_outlined.png'),
                                            color: const Color(0xff858998),
                                            width: min(3.w, 6),
                                            height: min(17.w, 34),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: -2.w + paddingValue,
                                right: -2.w + paddingValue,
                                bottom: 20.w,
                                top: 10.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.w),
                              child: Container(
                                width: screenWidth,
                                height: 216.w,
                                decoration: const BoxDecoration(
                                  color: offButtonColor,
                                ),
                                child: data.growthImageUrl != null
                                    ? Image.network(
                                        data.growthImageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Center(
                                        child: Text("등록된 이미지가 없습니다.",
                                            style: TextStyle(
                                                color: const Color(0xff9397A4),
                                                fontWeight: FontWeight.w500,
                                                fontSize: min(16.sp, 26)))),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 1.w + paddingValue,
                                right: 1.w + paddingValue,
                                bottom: 22.w),
                            child: SizedBox(
                              width: screenWidth,
                              child: Text(
                                data.diary,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: min(16.sp, 26),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingValue, vertical: 10.w),
                            child: Container(
                              width: screenWidth,
                              height: 1.w,
                              color: mainLineColor,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: paddingValue,
                              vertical: 15.w,
                            ),
                            child: Column(
                              // TODO 중복 위젯 -> 따로 빼서 리스트로 가져다 쓰기
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "체중",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(14.sp, 24),
                                  ),
                                ),
                                SizedBox(height: 14.w),
                                Container(
                                  width: screenWidth - 2 * paddingValue,
                                  height: min(48.w, 78),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(30.w)),
                                  child: Center(
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text:
                                              "${selectedBaby.value!.babyGrowthInfo.weight} g"),
                                      style: TextStyle(
                                        color: afterInputColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
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
                              horizontal: paddingValue,
                              vertical: 15.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "머리 직경",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(14.sp, 24),
                                  ),
                                ),
                                SizedBox(height: 14.w),
                                Container(
                                  width: screenWidth - 2 * paddingValue,
                                  height: min(48.w, 78),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(30.w)),
                                  child: Center(
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text:
                                              "${selectedBaby.value!.babyGrowthInfo.headDiameter} cm"),
                                      style: TextStyle(
                                        color: afterInputColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
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
                              horizontal: paddingValue,
                              vertical: 15.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "머리 둘레",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(14.sp, 24),
                                  ),
                                ),
                                SizedBox(height: 14.w),
                                Container(
                                  width: screenWidth - 2 * paddingValue,
                                  height: min(48.w, 78),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(30.w)),
                                  child: Center(
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text:
                                              "${selectedBaby.value!.babyGrowthInfo.headCircum} cm"),
                                      style: TextStyle(
                                        color: afterInputColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
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
                              horizontal: paddingValue,
                              vertical: 15.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "복부 둘레",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(14.sp, 24),
                                  ),
                                ),
                                SizedBox(height: 14.w),
                                Container(
                                  width: screenWidth - 2 * paddingValue,
                                  height: min(48.w, 78),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(30.w)),
                                  child: Center(
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text:
                                              "${selectedBaby.value!.babyGrowthInfo.abdomenCircum} cm"),
                                      style: TextStyle(
                                        color: afterInputColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
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
                                horizontal: paddingValue, vertical: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "허벅지 길이",
                                  style: TextStyle(
                                    color: offButtonTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(14.sp, 24),
                                  ),
                                ),
                                SizedBox(height: 14.w),
                                Container(
                                  width: screenWidth - 2 * paddingValue,
                                  height: min(48.w, 78),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(30.w)),
                                  child: Center(
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text:
                                              "${selectedBaby.value!.babyGrowthInfo.thighLength} cm"),
                                      style: TextStyle(
                                        color: afterInputColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: 60.w),
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
