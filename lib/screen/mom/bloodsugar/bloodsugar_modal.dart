import 'dart:math';

import 'package:cozy_for_mom_frontend/model/bloodsugar_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_bloodsugar_api_service.dart';

class BloodsugarModal extends StatefulWidget {
  final String time;
  final String period;
  final int id;
  final String bloodsugarValue;

  BloodsugarModal(
      {super.key,
      required this.time,
      required this.period,
      this.id = 0,
      required this.bloodsugarValue});

  @override
  State<BloodsugarModal> createState() => _BloodsugarModalState();
}

class _BloodsugarModalState extends State<BloodsugarModal> {
  bool _isHintVisible = true;
  late List<PregnantBloosdugar> pregnantBloodsugars;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = widget.bloodsugarValue;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    final globalData = Provider.of<MyDataModel>(context,
        listen: false); // record -> false 초기화, modify -> true 초기화
    ValueNotifier<bool> isButtonEnabled =
        ValueNotifier<bool>(widget.bloodsugarValue != '');
    BloodsugarApiService bloodsugarApi = BloodsugarApiService();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth - 2 * paddingValue,
            height: min(207.w, 307),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: contentBoxTwoColor,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('혈당 기록',
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: min(20.sp, 30))),
                Container(
                  width: 312.w,
                  height: min(80.w, 120),
                  padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          child: Text(widget.time,
                              style: TextStyle(
                                  color: offButtonTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: min(12.sp, 22))),
                        ),
                        SizedBox(
                          height: 32.w,
                          child: TextFormField(
                            controller: textController,
                            onChanged: (text) {
                              if (text.isEmpty) {
                                isButtonEnabled.value = false; // 입력값이 없을 때
                              } else {
                                isButtonEnabled.value = true; // 입력값이 있을 때
                              }
                            },
                            maxLength: 3,
                            textAlign: TextAlign.start,
                            cursorWidth: AppUtils.scaleSize(context, 0.8),
                            cursorHeight: min(14.sp, 24),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                suffixText: 'mg / dL',
                                suffixStyle: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: min(14.sp, 24)),
                                hintText: _isHintVisible ? 'mg / dL' : null,
                                hintStyle: TextStyle(
                                    color: beforeInputColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: min(16.sp, 26))),
                            cursorColor: primaryColor,
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: min(16.sp, 26)),
                            onTap: () {
                              setState(() {
                                _isHintVisible = false;
                              });
                            },
                          ),
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
                  height: min(56.w, 96),
                  padding: EdgeInsets.symmetric(
                      vertical: min(18.w, 28), horizontal: 50.w),
                  decoration: BoxDecoration(
                      color: isEnabled ? primaryColor : const Color(0xffC9DFF9),
                      borderRadius: BorderRadius.circular(12.w)),
                  child: InkWell(
                    onTap: () async {
                      if (isEnabled) {
                        late int? bloodsugarId;
                        widget.id > 0
                            ? bloodsugarId =
                                await bloodsugarApi.modifyBloodsugar(
                                    context,
                                    widget.id,
                                    globalData.selectedDate,
                                    '${widget.time} ${widget.period}',
                                    int.parse(textController.text))
                            : bloodsugarId =
                                await bloodsugarApi.recordBloodsugar(
                                    context,
                                    globalData.selectedDate,
                                    '${widget.time} ${widget.period}',
                                    int.parse(textController.text));
                        setState(() {
                          Navigator.pop(context, bloodsugarId);
                        });
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
