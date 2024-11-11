import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordIcon extends StatelessWidget {
  // TODO onTap 속성 추가
  final String recordTypeName;
  final String recordTypeKorName;
  final double imageWidth;
  final double imageHeight;
  final Color backgroundColor = const Color(0xffEDF0FA);
  const RecordIcon({
    super.key,
    required this.recordTypeName,
    required this.recordTypeKorName,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: min(76.w, 116),
          width: min(76.w, 116),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(9.w),
            ),
          ),
          child: Center(
            child: Image(
              image: AssetImage(
                "assets/images/icons/icon_$recordTypeName.png",
              ),
              width: imageWidth,
              height: imageHeight,
            ),
          ),
        ),
        SizedBox(
          height: 7.w,
        ),
        Text(
          recordTypeKorName,
          style: TextStyle(
              color: mainTextColor,
              fontWeight: FontWeight.w600,
              fontSize: min(14.sp, 24)),
        ),
      ],
    );
  }
}
