import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class NotificationSettingCard extends StatefulWidget {
  const NotificationSettingCard({super.key});

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

  @override
  void initState() {
    super.initState();
    xAlign = amAlign;
    amColor = selectedColor;
    pmColor = normalColor;
  }

  // 텍스트 입력 필드의 내용을 제어하고 관리
  final TextEditingController textEditingController = TextEditingController();
  bool isBeforeButtonEnabled = false;
  bool isAfterButtonEnabled = true;
  // 포커스 관리 (사용자가 특정 위젯에 포커스를 주거나 포커스를 뺄 때 이벤트를 처리)
  final FocusNode hourFocusNode = FocusNode();
  final FocusNode minuteFocusNode = FocusNode();
  String formatTime(String value) {
    if (value.length >= 3) {
      // HH:mm 형식으로 포맷팅
      return '${value.substring(0, 2)} : ${value.substring(2)}';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: screenWidth - 80,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 96,
                      height: 35,
                      decoration: BoxDecoration(
                          color: offButtonColor,
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
                                width: 45,
                                height: 29,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isBeforeButtonEnabled
                                        ? primaryColor
                                        : offButtonColor),
                                child: Text('오전',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isBeforeButtonEnabled
                                          ? Colors.white
                                          : offButtonTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
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
                                width: 45,
                                height: 29,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
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
                                      fontSize: 14,
                                    ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Center(
                        child: TextFormField(
                          autocorrect: true,
                          controller: textEditingController,
                          textAlign: TextAlign.center,
                          maxLength: 7,
                          showCursor: false,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
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
                              textEditingController.value =
                                  textEditingController.value.copyWith(
                                text: formatTime(value),
                                selection: TextSelection.collapsed(
                                    offset: formatTime(value).length),
                              );
                              // isButtonEnabled.value = true;
                            } else {
                              // isButtonEnabled.value = false;
                            }
                          },
                        ),
                      ),
                    ),
                  ])),
        ],
      ),
    );
  }
}
