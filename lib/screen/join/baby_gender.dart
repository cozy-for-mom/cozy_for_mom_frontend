import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/radio_button.dart';

class BabyGenderScreen extends StatefulWidget {
  const BabyGenderScreen({super.key});

  @override
  State<BabyGenderScreen> createState() => _BabyGenderScreenState();
}

class _BabyGenderScreenState extends State<BabyGenderScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<String> info = ['여아', '남아', '아직 모르겠어요'];
    return Stack(
      children: [
        const Positioned(
          top: 90,
          left: 20,
          child: Text('아기의 성별을 입력해주세요',
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
                  radioButtonType: RadioType.gender,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
