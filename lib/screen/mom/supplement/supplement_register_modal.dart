import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/service/mom_supplement_api_service.dart';

class SupplementRegisterModal extends StatefulWidget {
  SupplementRegisterModal({super.key});

  @override
  State<SupplementRegisterModal> createState() =>
      _SupplementRegisterModalState();
}

class _SupplementRegisterModalState extends State<SupplementRegisterModal> {
  @override
  Widget build(BuildContext context) {
    SupplementApiService supplementApi = SupplementApiService();
    TextEditingController nameController = TextEditingController();
    TextEditingController targetCountController = TextEditingController();
    ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);
    bool isNameEmpty = true;
    bool isTargetCountEmpty = true;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth - 40, // TODO 팝업창 너비 조정되도록 수정해야 함
            height: 302,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: contentBoxTwoColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('영양제 등록',
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
                SizedBox(
                  height: 176,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 312,
                          height: 80,
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 12),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(
                                  child: Text('이름',
                                      style: TextStyle(
                                          color: offButtonTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ),
                                SizedBox(
                                  height: 32,
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
                                    cursorHeight: 16,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                        hintText: '영양제 이름 입력',
                                        hintStyle: TextStyle(
                                            color: beforeInputColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                    cursorColor: beforeInputColor,
                                    style: const TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          width: 312,
                          height: 80,
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 12),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(
                                  child: Text('목표 섭취량',
                                      style: TextStyle(
                                          color: offButtonTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ),
                                SizedBox(
                                  height: 32,
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
                                    cursorHeight: 16,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                        hintText: '횟수 입력',
                                        hintStyle: TextStyle(
                                            color: beforeInputColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                    cursorColor: beforeInputColor,
                                    style: const TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ]),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ValueListenableBuilder<bool>(
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return Container(
                  width: 350,
                  height: 56,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                  decoration: BoxDecoration(
                      color: isEnabled ? primaryColor : const Color(0xffC9DFF9),
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      supplementApi.registerSupplement(nameController.text,
                          int.parse(targetCountController.text));
                    },
                    child: const Text(
                      '등록하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
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
