import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/bloodsugar_alarm.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/supplement_alarm.dart';

class AlarmSettingPage extends StatefulWidget {
  const AlarmSettingPage({super.key});

  @override
  State<AlarmSettingPage> createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends State<AlarmSettingPage> {
  bool isRecordActive = true; // 혈당 버튼이 기본적으로 활성화
  void toggleView() {
    setState(() {
      isRecordActive = !isRecordActive; // 버튼를 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 47,
            width: 400, // TODO 화면 너비에 맞춘 width로 수정해야 함
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
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
                width: 352,
                height: 53,
                decoration: BoxDecoration(
                    color: offButtonColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: !isRecordActive ? () => toggleView() : null,
                      child: Container(
                          width: 173,
                          height: 41,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isRecordActive
                                  ? primaryColor
                                  : offButtonColor),
                          child: Text('혈당',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isRecordActive
                                    ? Colors.white
                                    : offButtonTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ))),
                    ),
                    InkWell(
                      onTap: isRecordActive ? () => toggleView() : null,
                      child: Container(
                          width: 173,
                          height: 41,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: !isRecordActive
                                  ? primaryColor
                                  : offButtonColor),
                          child: Text('영양제',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isRecordActive
                                    ? Colors.white
                                    : offButtonTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ))),
                    ),
                  ],
                ),
              )),
          if (isRecordActive)
            const BloodsugarAlarm(), // showRecordView가 true인 경우 혈당 기록 페이지를 보여줌
          if (!isRecordActive)
            const SupplementAlarm(), // showRecordView가 false인 경우 기간별 조회 페이지를 보여줌
          // TODO 혈당 기간별 조회 페이지 구현해야 함
        ],
      ),
    );
  }
}