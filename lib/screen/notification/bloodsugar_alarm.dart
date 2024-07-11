import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_card.dart';

class BloodsugarAlarm extends StatelessWidget {
  const BloodsugarAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: 90,
      left: 0,
      right: 0,
      child: SizedBox(
        height: screenHeight - 200,
        child: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            AlarmSettingCard(text: '아침 혈당', type: CardType.bloodsugar),
            AlarmSettingCard(text: '저녁 혈당', type: CardType.bloodsugar),
          ]),
        ),
      ),
    );
  }
}
