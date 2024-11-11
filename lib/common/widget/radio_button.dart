import 'dart:math';

import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

enum RadioType { fetalInfo }

class BuildRadioButton extends StatefulWidget {
  final String title;
  final String value;
  final RadioType radioButtonType;
  const BuildRadioButton(
      {super.key,
      required this.title,
      required this.value,
      required this.radioButtonType});

  @override
  State<BuildRadioButton> createState() => _BuildRadioButtonState();
}

class _BuildRadioButtonState extends State<BuildRadioButton> {
  @override
  Widget build(BuildContext context) {
    final joinInputData = Provider.of<JoinInputData>(context);
    String? infoType;

    switch (widget.radioButtonType) {
      case RadioType.fetalInfo:
        infoType = joinInputData.fetalInfo;
        break;
    }
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if (mounted) {
          setState(() {
            if (widget.radioButtonType == RadioType.fetalInfo) {
              joinInputData.setFetalInfo(widget.value);
            }
          });
        }
      },
      child: Container(
        height: min(48.w, 78),
        padding: EdgeInsets.symmetric(
            vertical: 8.w, horizontal: widget.value == infoType ? 18.w : 20.w),
        margin: EdgeInsets.only(bottom: 15.w),
        decoration: BoxDecoration(
            color: contentBoxTwoColor,
            borderRadius: BorderRadius.circular(10.w),
            border: widget.value == infoType
                ? Border.all(
                    color: primaryColor, width: 2.w)
                : null),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: (widget.value == infoType)
                        ? mainTextColor
                        : beforeInputColor,
                    fontWeight: FontWeight.w400,
                    fontSize: min(14.sp, 24))),
            SizedBox(
                width: min(18.w, 28),
                child: Image(
                    image: AssetImage((widget.value == infoType)
                        ? 'assets/images/icons/radio_selected.png'
                        : 'assets/images/icons/radio_unselected.png'))),
          ],
        ),
      ),
    );
  }
}
