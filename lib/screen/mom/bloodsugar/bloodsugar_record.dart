import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_card.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class BloodsugarRecord extends StatelessWidget {
  const BloodsugarRecord({super.key});
  // List<String> times = ['아침', '점심', '저녁'];

  @override
  Widget build(BuildContext context) {
    List<String> times = ['아침', '점심', '저녁'];

    return Stack(
      children: <Widget>[
        Positioned(
            top: 177,
            left: 20,
            child: Container(
              width: 350,
              height: 63,
              decoration: const BoxDecoration(
                  color: Colors.white), // TODO 주간 캘린더 위젯으로 바꿔줘야 함
            )),
        Positioned(
          top: 288,
          left: 19,
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
