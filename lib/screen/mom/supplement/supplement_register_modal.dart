import 'dart:math';

import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_supplement_api_service.dart';
import 'package:flutter/services.dart';

class SupplementRegisterModal extends StatefulWidget {
  final void Function(int) onRegister;
  SupplementRegisterModal({super.key, required this.onRegister});

  @override
  State<SupplementRegisterModal> createState() =>
      _SupplementRegisterModalState();
}

class _SupplementRegisterModalState extends State<SupplementRegisterModal> {
  TextEditingController nameController = TextEditingController();
  TextEditingController targetCountController = TextEditingController();
  ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);
  bool isNameEmpty = true;
  bool isTargetCountEmpty = true;
  @override
  Widget build(BuildContext context) {
    SupplementApiService supplementApi = SupplementApiService();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth - 2 * paddingValue, // TODO 팝업창 너비 조정되도록 수정해야 함
            height: min(302.w, 462),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: contentBoxTwoColor,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('영양제 등록',
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: min(18.sp, 28))),
                SizedBox(
                  height: min(176.w, 266),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 312.w,
                          height: min(80.w, 120),
                          padding: EdgeInsets.only(
                              left: isTablet? 20.w : 24.w, right: isTablet? 20.w : 24.w, top: 12.w),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  child: Text('이름',
                                      style: TextStyle(
                                          color: offButtonTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: min(14.sp, 24))),
                                ),
                                SizedBox(
                                  height: min(32.w, 52),
                                  child: TextFormField(
                                    controller: nameController,
                                    onChanged: (text) {
                                      if (text.isEmpty) {
                                        isNameEmpty = true;
                                        isButtonEnabled.value = false;
                                      } else {
                                        isNameEmpty = false;
                                        if (!isNameEmpty &&
                                            !isTargetCountEmpty) {
                                          isButtonEnabled.value = true;
                                        }
                                      }
                                    },
                                    textAlign: TextAlign.start,
                                    maxLength: 15,
                                    cursorHeight:
                                        AppUtils.scaleSize(context, 16),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                        hintText: '영양제 이름 입력',
                                        hintStyle: TextStyle(
                                            color: beforeInputColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: min(16.sp, 26))),
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26)),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          width: 312.w,
                          height: min(80.w, 120),
                          padding: EdgeInsets.only(
                              left: isTablet? 20.w : 24.w, right: isTablet? 20.w : 24.w, top: 12.w),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  child: Text('목표 섭취량',
                                      style: TextStyle(
                                          color: offButtonTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: min(14.sp, 24))),
                                ),
                                SizedBox(
                                  height: min(32.w, 52),
                                  child: TextFormField(
                                    controller: targetCountController,
                                    onChanged: (text) {
                                      if (text.isEmpty) {
                                        isTargetCountEmpty = true;
                                        isButtonEnabled.value = false;
                                      } else {
                                        isTargetCountEmpty = false;
                                        if (!isNameEmpty &&
                                            !isTargetCountEmpty) {
                                          isButtonEnabled.value = true;
                                        }
                                      }
                                    },
                                    textAlign: TextAlign.start,
                                    maxLength: 2,
                                    cursorHeight:
                                        AppUtils.scaleSize(context, 16),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                        hintText: '횟수 입력',
                                        hintStyle: TextStyle(
                                            color: beforeInputColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: min(16.sp, 26))),
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(16.sp, 26)),
                                  ),
                                ),
                              ]),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.w),
          ValueListenableBuilder<bool>(
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return Container(
                  width: screenWidth - 2 * paddingValue,
                  height: min(56.w,96),
                  padding:
                      EdgeInsets.symmetric(vertical: min(18.w, 28), horizontal: 50.w),
                  decoration: BoxDecoration(
                      color: isEnabled ? primaryColor : const Color(0xffC9DFF9),
                      borderRadius: BorderRadius.circular(12.w)),
                  child: InkWell(
                    onTap: () async {
                      if (isEnabled) {
                        int? id = await supplementApi.registerSupplement(
                            context,
                            nameController.text,
                            int.parse(targetCountController.text));
                        Navigator.of(context).pop();
                        widget.onRegister(id!);
                      }
                    },
                    child: Text(
                      '등록하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: min(16.sp, 26)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
