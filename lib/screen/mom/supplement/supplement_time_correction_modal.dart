import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/services.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_supplement_api_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SupplementModal extends StatefulWidget {
  int id;
  String name;

  SupplementModal({super.key, required this.id, required this.name});

  @override
  State<SupplementModal> createState() => _SupplementModalState();
}

class _SupplementModalState extends State<SupplementModal> {
  bool isActivated = false;
  bool isBeforeButtonEnabled = false;
  bool isAfterButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    ValueNotifier<bool> isButtonEnabled = ValueNotifier<bool>(false);
    SupplementApiService supplementApi = SupplementApiService();
    final screenWidth = MediaQuery.of(context).size.width;
    final globalData = Provider.of<MyDataModel>(context, listen: false);

    late String currentTime;

    String formatTime(String value) {
      if (value.length >= 3) {
        // HH:mm 형식으로 포맷팅
        return '${value.substring(0, 2)} : ${value.substring(2)}';
      }
      return value;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth - 40, // TODO 팝업창 너비 조정되도록 수정해야 함
            height: 207,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: contentBoxTwoColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('영양제 기록',
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 20)),
                Container(
                    width: 312,
                    height: 80,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 84,
                            height: 32,
                            decoration: BoxDecoration(
                                color: contentBoxTwoColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isBeforeButtonEnabled = true;
                                      isAfterButtonEnabled = false;
                                    });
                                  },
                                  child: Container(
                                      width: 38,
                                      height: 26,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: isBeforeButtonEnabled
                                              ? primaryColor
                                              : contentBoxTwoColor),
                                      child: Text('오전',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isBeforeButtonEnabled
                                                ? Colors.white
                                                : offButtonTextColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ))),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isBeforeButtonEnabled = false;
                                      isAfterButtonEnabled = true;
                                    });
                                  },
                                  child: Container(
                                      width: 38,
                                      height: 26,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: isAfterButtonEnabled
                                              ? primaryColor
                                              : contentBoxTwoColor),
                                      child: Text('오후',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isAfterButtonEnabled
                                                ? Colors.white
                                                : offButtonTextColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ))),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 90,
                            child: TextFormField(
                              autocorrect: true,
                              controller: textController,
                              textAlign: TextAlign.center,
                              maxLength: 7,
                              showCursor: false,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: '00 : 00',
                                  hintStyle: TextStyle(
                                      color: offButtonTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24)),
                              style: const TextStyle(
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  textController.value =
                                      textController.value.copyWith(
                                    text: formatTime(value),
                                    selection: TextSelection.collapsed(
                                        offset: formatTime(value).length),
                                  );
                                  isButtonEnabled.value = true;
                                } else {
                                  isButtonEnabled.value = false;
                                }
                              },
                            ),
                          ),
                        ])),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ValueListenableBuilder<bool>(
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return Container(
                  width: screenWidth - 40,
                  height: 56,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                  decoration: BoxDecoration(
                      color: isEnabled ? primaryColor : const Color(0xffC9DFF9),
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      String time;
                      currentTime = DateFormat('yyyy-MM-dd')
                          .format(globalData.selectedDate); // TODO 캘린더 연동
                      List<String> timeParts = textController.text.split(':');
                      int hourValue = int.tryParse(timeParts[0]) ?? 0;
                      int minuteValue = int.tryParse(timeParts[1]) ?? 0;

                      if (!isAfterButtonEnabled && hourValue == 12) {
                        hourValue = 0; // 오전 12시는 00시로 표현
                      } else if (isAfterButtonEnabled && hourValue == 12) {
                        hourValue = 12; // 오후 12시는 12로 표현
                      } else if (isAfterButtonEnabled && hourValue != 12) {
                        hourValue =
                            (hourValue + 12) % 24; // 오후 시간을 24시간 형식으로 변환
                      }

                      time =
                          '$currentTime ${hourValue.toString().padLeft(2, '0')}:${minuteValue.toString().padLeft(2, '0')}:00';
                      supplementApi.modifySupplementIntake(
                          widget.id, widget.name, time);
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
