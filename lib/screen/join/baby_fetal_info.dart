import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;
    final List<String> info = ['단태아', '다태아'];
    return Stack(
      children: [
        Positioned(
          top: 50.h,
          left: paddingValue,
          child: Text('아기의 정보를 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: min(26.sp, 36))),
        ),
        Positioned(
          top: 95.h,
          left: paddingValue,
          child: Text('정보는 언제든지 마이로그에서 수정할 수 있어요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: min(14.sp, 24))),
        ),
        Positioned(
          top: 181.h,
          left: paddingValue,
          child: SizedBox(
            width: screenWidth - 2 * paddingValue,
            height: 476.w,
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
