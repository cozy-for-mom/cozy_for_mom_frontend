import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController hourEditingController = TextEditingController();
  final TextEditingController minuteEditingController = TextEditingController();
  // 포커스 관리 (사용자가 특정 위젯에 포커스를 주거나 포커스를 뺄 때 이벤트를 처리)
  final FocusNode hourFocusNode = FocusNode();
  final FocusNode minuteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 96,
              height: 35,
              decoration: const BoxDecoration(
                color: Color(0xffF0F0F5),
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment: Alignment(xAlign, 0),
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 96 * 0.5,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        xAlign = amAlign;
                        amColor = selectedColor;
                        pmColor = normalColor;
                      });
                    },
                    child: Align(
                      alignment: const Alignment(-1, 0),
                      child: Container(
                        width: 96 * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          '오전',
                          style: TextStyle(
                            color: amColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        xAlign = pmAlign;
                        amColor = normalColor;
                        pmColor = selectedColor;
                      });
                    },
                    child: Align(
                      alignment: const Alignment(1, 0),
                      child: Container(
                        width: 96 * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          '오후',
                          style: TextStyle(
                            color: pmColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                  child: TextFormField(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: TimePickerSpinner(
                                is24HourMode: false,
                                locale: const Locale('ko', ''),
                                time: DateTime(
                                    2023, // meaningless time
                                    1, // meaningless time
                                    1, // meaningless time
                                    int.parse(hourEditingController.text == ''
                                        ? "0"
                                        : (amColor == selectedColor
                                            ? hourEditingController.text
                                            : (int.parse(hourEditingController
                                                        .text) +
                                                    12)
                                                .toString())),
                                    int.parse(minuteEditingController.text == ''
                                        ? "0"
                                        : minuteEditingController.text)),
                                onTimeChange: (time) {
                                  if (time.hour > 12) {
                                    setState(() {
                                      xAlign = pmAlign;
                                      amColor = normalColor;
                                      pmColor = selectedColor;
                                    });
                                  }
                                  if (time.hour < 12) {
                                    setState(() {
                                      xAlign = amAlign;
                                      amColor = selectedColor;
                                      pmColor = normalColor;
                                    });
                                  }
                                  hourEditingController.text = time.hour > 12
                                      ? (time.hour - 12)
                                          .toString()
                                          .padLeft(2, '0')
                                      : time.hour.toString().padLeft(2, '0');
                                  minuteEditingController.text =
                                      time.minute.toString().padLeft(2, '0');
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    cursorHeight: 28,
                    controller: hourEditingController,
                    focusNode: hourFocusNode,
                    decoration: const InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(vertical: 7),
                      border: InputBorder.none,
                      hintText: '00',
                      hintStyle: TextStyle(
                        color: Color(0xff2B2D35),
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xff2B2D35),
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
                const Text(
                  " : ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: TextFormField(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: TimePickerSpinner(
                                is24HourMode: false,
                                locale: const Locale('ko', ''),
                                time: DateTime(
                                    2023, // meaningless time
                                    1, // meaningless time
                                    1, // meaningless time
                                    int.parse(hourEditingController.text == ''
                                        ? "0"
                                        : (amColor == selectedColor
                                            ? hourEditingController.text
                                            : (int.parse(hourEditingController
                                                        .text) +
                                                    12)
                                                .toString())),
                                    int.parse(minuteEditingController.text == ''
                                        ? "0"
                                        : minuteEditingController.text)),
                                onTimeChange: (time) {
                                  if (time.hour > 12) {
                                    setState(() {
                                      xAlign = pmAlign;
                                      amColor = normalColor;
                                      pmColor = selectedColor;
                                    });
                                  }
                                  if (time.hour < 12) {
                                    setState(() {
                                      xAlign = amAlign;
                                      amColor = selectedColor;
                                      pmColor = normalColor;
                                    });
                                  }
                                  hourEditingController.text = time.hour > 12
                                      ? (time.hour - 12)
                                          .toString()
                                          .padLeft(2, '0')
                                      : time.hour.toString().padLeft(2, '0');
                                  minuteEditingController.text =
                                      time.minute.toString().padLeft(2, '0');
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    readOnly: true,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    cursorHeight: 28,
                    controller: minuteEditingController,
                    focusNode: minuteFocusNode,
                    decoration: const InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(vertical: 7),
                      border: InputBorder.none,
                      hintText: '00',
                      hintStyle: TextStyle(
                        color: Color(0xff2B2D35),
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xff2B2D35),
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
