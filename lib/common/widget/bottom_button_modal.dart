import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomButtonWidget extends StatefulWidget {
  final bool isActivated;
  final String text;
  final VoidCallback tapped;
  const BottomButtonWidget(
      {super.key,
      required this.isActivated,
      required this.text,
      required this.tapped});

  @override
  State<BottomButtonWidget> createState() => _BottomButtonWidgetState();
}

class _BottomButtonWidgetState extends State<BottomButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter, // 그라데이션 시작점
          end: Alignment.topCenter, // 그라데이션 끝점
          colors: [
            Colors.white, // 시작 색상
            Colors.white.withOpacity(0.0), // 끝 색상
          ],
        ),
      ),
      padding:
          EdgeInsets.only(top: 20.w, bottom: screenWidth > 600 ? 24.w : 34.w),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: paddingValue),
        alignment: Alignment.center,
        height: min(56.w, 96),
        child: InkWell(
          onTap: widget.isActivated ? widget.tapped : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.isActivated ? primaryColor : induceButtonColor,
                borderRadius: BorderRadius.circular(12.w)),
            child: Text(widget.text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: min(16.sp, 26))),
          ),
        ),
      ),
    );
  }
}
