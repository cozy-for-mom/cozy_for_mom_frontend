import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';

class BloodsugarModal extends StatefulWidget {
  final String time;
  final String period;

  BloodsugarModal({super.key, required this.time, required this.period});

  @override
  State<BloodsugarModal> createState() => _BloodsugarModalState();
}

class _BloodsugarModalState extends State<BloodsugarModal> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    final globalState = Provider.of<MyDataModel>(context, listen: false);
    textController.text =
        (globalState.getBloodSugarData(widget.time + widget.period) ?? '');
    ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 350, // TODO 팝업창 너비 조정되도록 수정해야 함
            height: 207,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: contentBoxTwoColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('혈당 기록',
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 20)),
                Container(
                  width: 312,
                  height: 80,
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 16, bottom: 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Text(widget.time,
                              style: const TextStyle(
                                  color: offButtonTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ),
                        SizedBox(
                          height: 32,
                          child: TextFormField(
                            controller: textController,
                            onChanged: (text) {
                              if (text.isEmpty) {
                                globalState.setBloodSugarData(
                                    widget.time + widget.period, '-');
                                isButtonEnabled.value = false; // 입력값이 없을 때
                              } else {
                                globalState.setBloodSugarData(
                                    widget.time + widget.period, text);
                                isButtonEnabled.value = true; // 입력값이 없을 때
                              }
                            },
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixText: 'mg / dL',
                                suffixStyle: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                                hintText: 'mg / dL',
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
