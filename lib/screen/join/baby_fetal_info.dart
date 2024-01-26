import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/radio_button.dart';

class BabyFetalInfoScreen extends StatefulWidget {
  const BabyFetalInfoScreen({super.key});

  @override
  State<BabyFetalInfoScreen> createState() => _BabyFetalInfoScreenState();
}

class _BabyFetalInfoScreenState extends State<BabyFetalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<String> info = ['단태아', '다태아', '아직 모르겠어요'];
    return Stack(
      children: [
        const Positioned(
          top: 90,
          left: 20,
          child: Text('아기의 정보를 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 135,
          left: 20,
          child: Text('정보는 언제든지 마이로그에서 수정할 수 있어요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ),
        Positioned(
          top: 221,
          left: 20,
          child: SizedBox(
            width: screenWidth - 40,
            height: 476,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: info.map((title) {
                return BuildRadioButton(
                  title: title,
                  value: title,
                  radioButtonType: RadioType.fetalInfo,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
