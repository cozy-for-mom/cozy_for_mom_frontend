import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class SelectBottomModal extends StatelessWidget {
  final String selec1;
  final String selec2;
  final VoidCallback tap1;
  final VoidCallback tap2;
  SelectBottomModal(
      {super.key,
      required this.selec1,
      required this.selec2,
      required this.tap1,
      required this.tap2});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return SizedBox(
      width: screenWidth - 2 * paddingValue,
      height: isTablet? 234.w - paddingValue : 234.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            width: screenWidth,
            height: 148.w - paddingValue,
            decoration: BoxDecoration(
                color: contentBoxTwoColor,
                borderRadius: BorderRadius.circular(20.w)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: tap1,
                  child: Text(selec1,
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: min(16.sp, 26))),
                ),
                InkWell(
                  onTap: tap2,
                  child: Text(selec2,
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: min(16.sp, 26))),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.w),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              width: screenWidth,
              height: min(56.w, 96),
              decoration: BoxDecoration(
                  color: induceButtonColor,
                  borderRadius: BorderRadius.circular(12.w)),
              child: Text('취소',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: min(16.sp, 26))),
            ),
          ),
        ],
      ),
    );
  }
}
