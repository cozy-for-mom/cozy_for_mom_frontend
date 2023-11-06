import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

enum CardType { bloodsugar, supplement }

class AlarmSettingCard extends StatefulWidget {
  final String text;
  final CardType type;
  const AlarmSettingCard({super.key, required this.text, required this.type});

  @override
  State<AlarmSettingCard> createState() => _AlarmSettingCardState();
}

class _AlarmSettingCardState extends State<AlarmSettingCard> {
  bool isAlarmOn = false; // 초기 알람 상태

  @override
  Widget build(BuildContext context) {
    Widget childWiget;

    switch (widget.type) {
      case CardType.bloodsugar:
        childWiget = Text(widget.text,
            style: const TextStyle(
                color: mainTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 18));
      case CardType.supplement:
        childWiget = Row(children: [
          Text(widget.text,
              style: const TextStyle(
                  color: afterInputColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          const SizedBox(width: 5),
          Container(
            width: 57,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xffFEEEEE),
                borderRadius: BorderRadius.circular(8)),
            child: const Text(
              '하루 -회',
              style: TextStyle(
                  color: Color(0xffFF9797),
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          )
        ]);
    }
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        width: 350,
        height: 164,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            childWiget,
            CupertinoSwitch(
              value: isAlarmOn,
              onChanged: (value) {
                setState(() {
                  isAlarmOn = value;
                });
              },
              activeColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
