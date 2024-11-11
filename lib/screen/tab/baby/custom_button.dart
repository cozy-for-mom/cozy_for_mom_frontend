import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String imagePath;
  const CustomButton({super.key, required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 160.w : 170.w,
      height: min(80.w, 130),
      decoration: BoxDecoration(
          color: contentBoxColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text,
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: min(14.sp, 24))),
          Image(image: AssetImage(imagePath), width: min(31.w, 51), height: min(31.w, 51))
        ],
      ),
    );
  }
}
