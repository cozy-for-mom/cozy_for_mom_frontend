import 'dart:math';

import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class BabyDuedateInputScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const BabyDuedateInputScreen({super.key, required this.updateValidity});

  @override
  State<BabyDuedateInputScreen> createState() => _BabyDuedateInputScreenState();
}

class _BabyDuedateInputScreenState extends State<BabyDuedateInputScreen> {
  TextEditingController dueDateController = TextEditingController();
  TextEditingController lastMensesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    final joinInputData = Provider.of<JoinInputData>(context);
    dueDateController.text = joinInputData.dueDate;
    lastMensesController.text = joinInputData.laseMensesDate;
    return Stack(
      children: [
        Positioned(
          top: 50.h,
          left: paddingValue,
          child: Text('출산 예정일을 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: min(26.sp, 36))),
        ),
        Positioned(
          top: 95.h,
          left: paddingValue,
          child: Text('출산 예정일은 마이로그에서 수정할 수 있어요.',
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
              Text('출산예정일',
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
                  alignment: Alignment.center,
                  child: Center(
                    child: TextFormField(
                      controller: dueDateController,
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
                            // TODO 자동완성 후, 지웠다가 다시 입력할때 자동완성 안됨
                            String parsedDate;
                            if (value.length == 8 && _isNumeric(value)) {
                              parsedDate = DateFormat('yyyy.MM.dd')
                                  .format(DateTime.parse(value));
                              // 오늘 날짜보다 과거인 경우 내일 날짜로 변경
                              if (DateTime.parse(value)
                                  .isBefore(DateTime.now())) {
                                parsedDate = DateFormat('yyyy.MM.dd').format(
                                    DateTime.now()
                                        .add(const Duration(days: 1)));
                              }
                            } else {
                              parsedDate = value;
                            }
                            joinInputData.dueDate = parsedDate;
                            widget.updateValidity(
                                dueDateController.text.isNotEmpty &
                                    lastMensesController.text.isNotEmpty);
                          });
                        }
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
              Text('마지막 월경 시작일',
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
                      controller: lastMensesController,
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
                              // 출산예정일 날짜보다 미래인 경우 출산예정일 - 280일로 변경
                              if (DateTime.parse(value).isAfter(DateFormat('yyyy.MM.dd').parse(joinInputData.dueDate))) {
                                parsedDate = DateFormat('yyyy.MM.dd').format(
                                    DateFormat('yyyy.MM.dd').parse(joinInputData.dueDate)
                                        .subtract(const Duration(days: 280)));
                              }
                            } else {
                              parsedDate = value;
                            }
                            joinInputData.laseMensesDate = parsedDate;
                            widget.updateValidity(
                                dueDateController.text.isNotEmpty &
                                    lastMensesController.text.isNotEmpty);
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
