import 'dart:math';

import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class MomNameBirthInputScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const MomNameBirthInputScreen({super.key, required this.updateValidity});

  @override
  State<MomNameBirthInputScreen> createState() =>
      _MomNameBirthInputScreenState();
}

class _MomNameBirthInputScreenState extends State<MomNameBirthInputScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    final joinInputData = Provider.of<JoinInputData>(context);
    nameController.text = joinInputData.name;
    birthController.text = joinInputData.birth;
    return Stack(
      children: [
        Positioned(
          top: 50.h,
          left: paddingValue,
          child: Text('산모님에 대해 알려주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: min(26.sp, 36))),
        ),
        Positioned(
          top: 95.h,
          left: paddingValue,
          child: Text('안심하세요! 개인정보는 외부에 공개되지 않아요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: min(14.sp, 24))),
        ),
        Positioned(
          top: 150.h,
          left: paddingValue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이름',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: min(14.sp, 24))),
              SizedBox(height: 10.w),
              Container(
                  width: screenWidth - 2 * paddingValue,
                  height: min(48.w, 78),
                  padding: EdgeInsets.symmetric(horizontal: min(20.w, 30)),
                  decoration: BoxDecoration(
                      color: contentBoxTwoColor,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Center(
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.start,
                      maxLength: 24,
                      cursorColor: primaryColor,
                      cursorHeight: min(14.sp, 24),
                      cursorWidth: 1.2.w,
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: min(14.sp, 24)),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.w),
                        border: InputBorder.none,
                        hintText: '이름을 입력해주세요',
                        hintStyle: TextStyle(
                            color: beforeInputColor,
                            fontWeight: FontWeight.w400,
                            fontSize: min(14.sp, 24)),
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            joinInputData.setName(value);
                          });
                        }
                        widget.updateValidity(nameController.text.isNotEmpty &&
                            birthController.text.isNotEmpty);
                      },
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
          top: isTablet ? (254 + 25).h : 254.h,
          left: paddingValue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('생년월일',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: min(14.sp, 24))),
              SizedBox(height: 10.w),
              Container(
                  width: screenWidth - 2 * paddingValue,
                  height: min(48.w, 78),
                  padding:
                      EdgeInsets.symmetric(horizontal: min(20.w, 30)),
                  decoration: BoxDecoration(
                      color: contentBoxTwoColor,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Center(
                    child: TextFormField(
                      controller: birthController,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.start,
                      maxLength: 10,
                      cursorColor: primaryColor,
                      cursorHeight: min(14.sp, 24),
                      cursorWidth: 1.2.w,
                      style: TextStyle(
                          color: mainTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: min(14.sp, 24)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.w),
                        border: InputBorder.none,
                        hintText: 'YYYY.MM.DD',
                        hintStyle: TextStyle(
                            color: beforeInputColor,
                            fontWeight: FontWeight.w400,
                            fontSize: min(14.sp, 24)),
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            String parsedDate;
                            if (value.length == 8 && _isNumeric(value)) {
                              parsedDate = DateFormat('yyyy.MM.dd')
                                  .format(DateTime.parse(value));
                              // 오늘 날짜보다 미래인 경우 어제 날짜로 변경
                              if (DateTime.parse(value).isAfter(DateTime.now())) {
                                parsedDate = DateFormat('yyyy.MM.dd').format(
                                    DateTime.now()
                                        .subtract(const Duration(days: 1)));
                              }
                            } else {
                              parsedDate = value;
                            }
                            joinInputData.setBirth(parsedDate);
                            widget.updateValidity(
                                nameController.text.isNotEmpty &&
                                    birthController.text.isNotEmpty);
                          });
                        }
                      },
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }
}

bool _isNumeric(String value) {
  final numericRegex = RegExp(r'^[0-9]+$');
  return numericRegex.hasMatch(value);
}
