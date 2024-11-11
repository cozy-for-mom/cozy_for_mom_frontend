import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';

class BloodsugarRecord extends StatelessWidget {
  const BloodsugarRecord({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    List<String> times = ['아침', '점심', '저녁'];

    return Stack(
      children: <Widget>[
        Positioned(
            top: isTablet? 160.h : 180.h,
            left: paddingValue,
            child: SizedBox(
              width: screenWidth - 2 * paddingValue,
              child: const WeeklyCalendar(),
            )),
        Positioned(
          top: isTablet? 268.h : 288.h,  // TODO 스크롤을 적용할지 고민
          left: 0.w,
          right: 0.w,
          child: Column(
            children: times.map((time) {
              return Column(
                children: [
                  BloodsugarCard(time: time),
                  Padding(padding: EdgeInsets.only(bottom: 5.h)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
