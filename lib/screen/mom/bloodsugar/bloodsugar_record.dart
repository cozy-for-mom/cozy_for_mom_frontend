import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_card.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';

class BloodsugarRecord extends StatelessWidget {
  const BloodsugarRecord({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<String> times = ['아침', '점심', '저녁'];

    return Stack(
      children: <Widget>[
        Positioned(
            top: AppUtils.scaleSize(context, 180),
            left: AppUtils.scaleSize(context, 20),
            child: SizedBox(
              height: AppUtils.scaleSize(context, 100),
              width: screenWidth - AppUtils.scaleSize(context, 40),
              child: const WeeklyCalendar(),
            )),
        Positioned(
          top: AppUtils.scaleSize(context, 288),
          left: 0,
          right: 0,
          child: Column(
            children: times.map((time) {
              return Column(
                children: [
                  BloodsugarCard(time: time),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: AppUtils.scaleSize(context, 5))),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
