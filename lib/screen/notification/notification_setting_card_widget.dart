import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationSettingCard extends StatefulWidget {
  final String? initialTime;
  final Function(String) targetTimeAt;
  const NotificationSettingCard(
      {super.key, required this.targetTimeAt, this.initialTime});

  @override
  State<NotificationSettingCard> createState() =>
      _NotificationSettingCardState();
}

const double amAlign = -1;
const double pmAlign = 1;
const Color selectedColor = Color(0xffF0F0F5);
const Color normalColor = primaryColor;

class _NotificationSettingCardState extends State<NotificationSettingCard> {
  late double xAlign;
  late Color amColor;
  late Color pmColor;

  // 텍스트 입력 필드의 내용을 제어하고 관리
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode hourFocusNode = FocusNode();
  final FocusNode minuteFocusNode = FocusNode();

  bool isBeforeButtonEnabled = false;
  bool isAfterButtonEnabled = false;
  String formatTime(String value) {
    if (value.length >= 3) {
      // HH:mm 형식으로 포맷팅
      return '${value.substring(0, 2)} : ${value.substring(2)}';
    }
    return value;
  }

  // 24시간 기준으로 표현
  String convert24Time(List<String> timeParts) {
    int hourValue = int.tryParse(timeParts[0]) ?? 0;
    int minuteValue = int.tryParse(timeParts[1]) ?? 0;

    if (!isAfterButtonEnabled && hourValue == 12) {
      hourValue = 0; // 오전 12시는 00시로 표현
    } else if (isAfterButtonEnabled && hourValue == 12) {
      hourValue = 12; // 오후 12시는 12로 표현
    } else if (isAfterButtonEnabled && hourValue != 12) {
      hourValue = (hourValue + 12) % 24; // 오후 시간을 24시간 형식으로 변환
    }
    return '${hourValue.toString().padLeft(2, '0')}:${minuteValue.toString().padLeft(2, '0')}';
  }

  // 오후 시간 포맷팅
  String formatPmTime(String value) {
    int hour = int.parse(value.substring(0, 2));
    String minute =
        value.substring(3).padLeft(2, '0'); // 분이 한 자릿수일 경우 앞에 '0' 추가

    if (hour >= 12) {
      isAfterButtonEnabled = true;
      if (hour == 12) {
        return '${hour.toString().padLeft(2, '0')} : $minute';
      } else {
        return '${(hour - 12).toString().padLeft(2, '0')} : $minute';
      }
    } else {
      isBeforeButtonEnabled = true;
      if (hour == 0) {
        return '${(hour + 12).toString().padLeft(2, '0')} : $minute';
      } else {
        return '${hour.toString().padLeft(2, '0')} : $minute';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    xAlign = amAlign;
    amColor = selectedColor;
    pmColor = normalColor;
    if (widget.initialTime != null) {
      textEditingController.text = formatPmTime(widget.initialTime!);
    } else {
      isBeforeButtonEnabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<String> timeParts = textEditingController.text.split(':');

    return Container(
      height: AppUtils.scaleSize(context, 78),
      width: screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(AppUtils.scaleSize(context, 20)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: AppUtils.scaleSize(context, 96),
          height: AppUtils.scaleSize(context, 35),
          decoration: BoxDecoration(
              color: offButtonColor, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    isBeforeButtonEnabled = true;
                    isAfterButtonEnabled = false;
                    if (widget.initialTime != null) {
                      widget.targetTimeAt(convert24Time(timeParts));
                    }
                  });
                },
                child: Container(
                    width: AppUtils.scaleSize(context, 45),
                    height: AppUtils.scaleSize(context, 29),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isBeforeButtonEnabled
                            ? primaryColor
                            : offButtonColor),
                    child: Center(
                      child: Text('오전',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isBeforeButtonEnabled
                                ? Colors.white
                                : offButtonTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: AppUtils.scaleSize(context, 14),
                          )),
                    )),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isBeforeButtonEnabled = false;
                    isAfterButtonEnabled = true;
                    if (widget.initialTime != null) {
                      widget.targetTimeAt(convert24Time(timeParts));
                    }
                  });
                },
                child: Container(
                    width: AppUtils.scaleSize(context, 45),
                    height: AppUtils.scaleSize(context, 29),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isAfterButtonEnabled
                            ? primaryColor
                            : offButtonColor),
                    child: Center(
                      child: Text('오후',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isAfterButtonEnabled
                                ? Colors.white
                                : offButtonTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: AppUtils.scaleSize(context, 14),
                          )),
                    )),
              ),
            ],
          ),
        ),
        Container(
          width: AppUtils.scaleSize(context, 89),
          alignment: Alignment.center,
          child: Center(
            child: TextFormField(
              autocorrect: true,
              controller: textEditingController,
              textAlignVertical: TextAlignVertical.bottom,
              textAlign: TextAlign.center,
              maxLength: 7,
              showCursor: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                // underline과의 기본 패딩값 없애기(텍스트 중앙정렬 위해)
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                counterText: '',
                hintText: '00 : 00',
                hintStyle: TextStyle(
                    color: offButtonTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppUtils.scaleSize(context, 24),
                    height: AppUtils.scaleSize(context, 1)),
              ),
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scaleSize(context, 24),
                  height: AppUtils.scaleSize(context, 1)),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  textEditingController.value =
                      textEditingController.value.copyWith(
                    text: formatTime(value),
                    selection: TextSelection.collapsed(
                        offset: formatTime(value).length),
                  );
                  String time;
                  if (textEditingController.text.contains(':')) {
                    timeParts = textEditingController.text.split(':');

                    if (timeParts[0].length + timeParts[1].length == 6) {
                      // 각각 공백 포함 3글자
                      time = convert24Time(
                          timeParts); // TODO RangeError (index): Invalid value: Only valid value is 0: 1 수정
                      widget.targetTimeAt(time);
                    }
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }
}
