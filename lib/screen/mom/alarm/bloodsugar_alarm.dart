import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_card.dart';

class BloodsugarAlarm extends StatelessWidget {
  const BloodsugarAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
            top: 204,
            left: 20,
            child: AlarmSettingCard(text: '아침 혈당', type: CardType.bloodsugar))
      ],
    );
  }
}
