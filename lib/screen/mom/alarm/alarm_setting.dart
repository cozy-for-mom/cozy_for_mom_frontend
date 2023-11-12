import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/bloodsugar_alarm.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/supplement_alarm.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';

enum CardType { bloodsugar, supplement }

class AlarmSettingPage extends StatefulWidget {
  final CardType type;
  const AlarmSettingPage({super.key, required this.type});

  @override
  State<AlarmSettingPage> createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends State<AlarmSettingPage> {
  bool isBloodSugarButtonEnabled = false;
  bool isSupplementButtonEnabled = false;
  @override
  void initState() {
    super.initState();
    // 초기에 전달받은 타입에 따라 버튼 상태 초기화
    switch (widget.type) {
      case CardType.bloodsugar:
        isBloodSugarButtonEnabled = true;
        break;
      case CardType.supplement:
        isSupplementButtonEnabled = true;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 47,
            width: 400, // TODO 화면 너비에 맞춘 width로 수정해야함
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    const Text('알림 설정',
                        style: TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    const Spacer(),
                  ]),
            ),
          ),
          Positioned(
              top: 104,
              left: 20,
              child: Container(
                width: 351, // TODO 화면 너비에 맞춘 width로 수정해야함
                height: 53,
                decoration: BoxDecoration(
                    color: offButtonColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isBloodSugarButtonEnabled = true;
                          isSupplementButtonEnabled = false;
                        });
                      },
                      child: Container(
                          width: isBloodSugarButtonEnabled
                              ? 173
                              : 153, // 이렇게 해야 위젯끼리 안 겹침
                          height: 41,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isBloodSugarButtonEnabled
                                  ? primaryColor
                                  : offButtonColor),
                          child: Text('혈당',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isBloodSugarButtonEnabled
                                    ? Colors.white
                                    : offButtonTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ))),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isBloodSugarButtonEnabled = false;
                          isSupplementButtonEnabled = true;
                        });
                      },
                      child: Container(
                          width: isSupplementButtonEnabled ? 173 : 153,
                          height: 41,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isSupplementButtonEnabled
                                  ? primaryColor
                                  : offButtonColor),
                          child: Text('영양제',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSupplementButtonEnabled
                                    ? Colors.white
                                    : offButtonTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ))),
                    ),
                  ],
                ),
              )),
          isBloodSugarButtonEnabled
              ? const BloodsugarAlarm()
              : const SupplementAlarm(),
        ],
      ),
      floatingActionButton:
          const CustomFloatingButton(), // TODO 버튼 클릭 시 알림 등록 페이지로 이동
    );
  }
}
