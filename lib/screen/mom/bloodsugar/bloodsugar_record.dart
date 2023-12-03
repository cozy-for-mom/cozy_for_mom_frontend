import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_card.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';

class BloodsugarRecord extends StatelessWidget {
  const BloodsugarRecord({super.key});
  // List<String> times = ['아침', '점심', '저녁'];

  @override
  Widget build(BuildContext context) {
    List<String> times = ['아침', '점심', '저녁'];

    return Stack(
      children: <Widget>[
        const Positioned(
            top: 177,
            left: 20,
            child: SizedBox(
              height: 100,
              width: 350,
              child: WeeklyCalendar(),
            )),
        Positioned(
          top: 288,
          left: 0,
          right: 0,
          child: Column(
            children: times.map((time) {
              return Column(
                children: [
                  BloodsugarCard(time: time),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
