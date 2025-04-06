import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

// 아이콘 + 텍스트 버튼 (커스텀버튼 위젯)
class CustomTextButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final FontWeight textWeight;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final void Function() onPressed;

  CustomTextButton({
    required this.text,
    required this.textColor,
    required this.textWeight,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageWidth,
              height: imageHeight,
            ),
            SizedBox(height: 10.w),
            Text(
              text,
              style: TextStyle(
                  color: textColor, fontWeight: textWeight, fontSize: min(14.sp, 24)),
            ),
          ],
        ),
      ),
    );
  }
}
