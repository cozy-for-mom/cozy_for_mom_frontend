import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_record.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_view.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';

import 'package:provider/provider.dart';

class BloodsugarPage extends StatefulWidget {
  const BloodsugarPage({super.key});

  @override
  State<BloodsugarPage> createState() => _BloodsugarPageState();
}

class _BloodsugarPageState extends State<BloodsugarPage> {
  bool isRecordActive = true; // 기록하기 버튼이 기본적으로 활성화
  void toggleView() {
    setState(() {
      isRecordActive = !isRecordActive; // 버튼를 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmall = screenHeight < 670;
    final paddingValue = 20.w;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned(
              top: isSmall ? 0.w : 40.w,
              width: screenWidth,
              child: Padding(
                padding: EdgeInsets.only(
                    top: paddingValue, bottom: paddingValue - 20.w, right: 8.w),
                child: Consumer<MyDataModel>(builder: (context, globalData, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image(
                          image: const AssetImage(
                              'assets/images/icons/back_ios.png'),
                          width: min(34.w, 44),
                          height: min(34.w, 44),
                          color: mainTextColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: min(30.w, 40),
                        height: min(30.w, 40),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            DateFormat('M.d E', 'ko_KR')
                                .format(globalData.selectedDate),
                            style: TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(18.sp, 28),
                            ),
                          ),
                          IconButton(
                            alignment: AlignmentDirectional.centerStart,
                            icon: const Icon(Icons.expand_more),
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                elevation: 0.0,
                                context: context,
                                builder: (context) {
                                  return Wrap(children: [
                                    MonthCalendarModal(limitToday: true)
                                  ]);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          icon: Image(
                              image: const AssetImage(
                                  'assets/images/icons/alert.png'),
                              height: min(32.w, 42),
                              width: min(32.w, 42)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AlarmSettingPage(
                                          type: CardType.bloodsugar,
                                        )));
                          })
                    ],
                  );
                }),
              )),
          Positioned(
              top: isSmall? 90.h : 110.h,
              left: paddingValue,
              child: Container(
                width: screenWidth - 2 * paddingValue,
                height: min(53.w, 93),
                decoration: BoxDecoration(
                    color: offButtonColor,
                    borderRadius: BorderRadius.circular(30.w)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: !isRecordActive ? () => toggleView() : null,
                      child: Container(
                          width: isRecordActive
                              ? 193.w - paddingValue
                              : 173.w - paddingValue,
                          height: min(41.w, 71),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.w),
                              color: isRecordActive
                                  ? primaryColor
                                  : offButtonColor),
                          child: Center(
                            child: Text('기록하기',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isRecordActive
                                      ? Colors.white
                                      : offButtonTextColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: min(16.sp, 26),
                                )),
                          )),
                    ),
                    InkWell(
                      onTap: isRecordActive ? () => toggleView() : null,
                      child: Container(
                          width: !isRecordActive
                              ? 193.w - paddingValue
                              : 173.w - paddingValue,
                          height: min(41.w, 71),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.w),
                              color: !isRecordActive
                                  ? primaryColor
                                  : offButtonColor),
                          child: Center(
                            child: Text('기간별 조회',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !isRecordActive
                                      ? Colors.white
                                      : offButtonTextColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: min(16.sp, 26),
                                )),
                          )),
                    ),
                  ],
                ),
              )),
          if (isRecordActive)
            const BloodsugarRecord(), // showRecordView가 true인 경우 혈당 기록 페이지를 보여줌
          if (!isRecordActive)
            const BloodsugarView(), // showRecordView가 false인 경우 기간별 조회 페이지를 보여줌
        ],
      ),
    );
  }
}
