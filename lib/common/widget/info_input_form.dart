import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class InfoInputForm extends StatefulWidget {
  final String title;
  final String hint;
  final String unit;
  final TextEditingController? controller;
  final VoidCallback? onChanged;

  const InfoInputForm(
      {super.key,
      required this.title,
      this.hint = '',
      this.unit = '',
      this.controller,
      this.onChanged});

  @override
  State<InfoInputForm> createState() => _InfoInputFormState();
}

class _InfoInputFormState extends State<InfoInputForm> {
  bool _isHintVisible = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;
    if (widget.controller!.text.isNotEmpty) {
      _isHintVisible = false;
    }

    return SizedBox(
      width: screenWidth - 2 * paddingValue,
      height: 83.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title,
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: min(14.sp, 24))),
          SizedBox(height: 14.w),
          Container(
              width: screenWidth - 2 * paddingValue,
              height: min(48.w, 78),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.w)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: widget.controller,
                      maxLength: 8,
                      textAlign: TextAlign.start,
                      cursorColor: primaryColor,
                      cursorHeight: min(16.sp, 26),
                      cursorWidth: 1.5.w,
                      style: TextStyle(
                          color: afterInputColor,
                          fontWeight: FontWeight.w500,
                          fontSize: min(16.sp, 26)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: _isHintVisible ? widget.hint : null,
                        hintStyle: TextStyle(
                            color: beforeInputColor,
                            fontWeight: FontWeight.w500,
                            fontSize: min(16.sp, 26)),
                      ),
                      onTap: () {
                        setState(() {
                          _isHintVisible = false;
                        });
                      },
                      onChanged: (text) {
                        setState(() {
                          widget.onChanged?.call();
                        });
                      },
                    ),
                  ),
                  _isHintVisible
                      ? Container()
                      : Text(
                          ' ${widget.unit}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: min(16.sp, 26)),
                        )
                ],
              )),
        ],
      ),
    );
  }
}
