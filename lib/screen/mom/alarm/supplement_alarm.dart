import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_card.dart';

class SupplementAlarm extends StatelessWidget {
  const SupplementAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: 204,
      left: 0,
      right: 0,
      child: SizedBox(
        height: screenHeight - 200,
        child: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            AlarmSettingCard(text: '철분제', type: CardType.supplement),
            AlarmSettingCard(text: '비타민 B', type: CardType.supplement),
            AlarmSettingCard(text: '엽산', type: CardType.supplement),
          ]),
        ),
      ),
    );
  }
}
