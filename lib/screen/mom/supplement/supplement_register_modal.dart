import 'package:cozy_for_mom_frontend/model/supplement_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth -
                AppUtils.scaleSize(context, 40), // TODO 팝업창 너비 조정되도록 수정해야 함
            height: AppUtils.scaleSize(context, 302),
            padding: EdgeInsets.symmetric(
                horizontal: AppUtils.scaleSize(context, 20)),
            decoration: BoxDecoration(
              color: contentBoxTwoColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('영양제 등록',
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppUtils.scaleSize(context, 18))),
                SizedBox(
                  height: AppUtils.scaleSize(context, 176),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: AppUtils.scaleSize(context, 312),
                          height: AppUtils.scaleSize(context, 80),
                          padding: EdgeInsets.only(
                              left: AppUtils.scaleSize(context, 24),
                              right: AppUtils.scaleSize(context, 24),
                              top: AppUtils.scaleSize(context, 12)),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
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
                                          fontSize:
                                              AppUtils.scaleSize(context, 14))),
                                ),
                                SizedBox(
                                  height: AppUtils.scaleSize(context, 32),
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
                                            fontSize: AppUtils.scaleSize(
                                                context, 16))),
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            AppUtils.scaleSize(context, 16)),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          width: AppUtils.scaleSize(context, 312),
                          height: AppUtils.scaleSize(context, 80),
                          padding: EdgeInsets.only(
                              left: AppUtils.scaleSize(context, 24),
                              right: AppUtils.scaleSize(context, 24),
                              top: AppUtils.scaleSize(context, 12)),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
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
                                          fontSize:
                                              AppUtils.scaleSize(context, 14))),
                                ),
                                SizedBox(
                                  height: AppUtils.scaleSize(context, 32),
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
                                            fontSize: AppUtils.scaleSize(
                                                context, 16))),
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            AppUtils.scaleSize(context, 16)),
                                  ),
                                ),
                              ]),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          SizedBox(height: AppUtils.scaleSize(context, 18)),
          ValueListenableBuilder<bool>(
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return Container(
                  width: screenWidth - AppUtils.scaleSize(context, 40),
                  height: AppUtils.scaleSize(context, 56),
                  padding: EdgeInsets.symmetric(
                      vertical: AppUtils.scaleSize(context, 18),
                      horizontal: AppUtils.scaleSize(context, 50)),
                  decoration: BoxDecoration(
                      color: isEnabled ? primaryColor : const Color(0xffC9DFF9),
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () async {
                      if (isEnabled) {
                        int id = await supplementApi.registerSupplement(
                            nameController.text,
                            int.parse(targetCountController.text));
                        Navigator.of(context).pop();
                        widget.onRegister(id);
                      }
                    },
                    child: Text(
                      '등록하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppUtils.scaleSize(context, 16)),
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
