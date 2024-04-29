import 'package:cozy_for_mom_frontend/screen/mom/alarm/bloodsugar_alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_record.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_view.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';

import 'package:provider/provider.dart';

class BloodsugarPage extends StatefulWidget {
  const BloodsugarPage({super.key});

  @override
  State<BloodsugarPage> createState() => _BloodsugarPageState();
}

class _BloodsugarPageState extends State<BloodsugarPage> {
  bool isRecordActive = true; // 기록하기 버튼이 기본적으로 활성화
  void toggleView() {
    setState(() {
      isRecordActive = !isRecordActive; // 버튼를 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 47,
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Consumer<MyDataModel>(builder: (context, globalData, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('M.d E', 'ko_KR')
                                .format(globalData.selectedDate),
                            style: const TextStyle(
                              color: mainTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            alignment: AlignmentDirectional.centerStart,
                            icon: const Icon(Icons.expand_more),
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: contentBoxTwoColor
                                    .withOpacity(0.0), // 팝업창 자체 색 : 투명
                                context: context,
                                builder: (context) {
                                  return const MonthCalendarModal();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      IconButton(
                          icon: const Image(
                              image:
                                  AssetImage('assets/images/icons/alert.png'),
                              height: 32,
                              width: 32),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AlarmSettingPage(
                                          type: CardType.supplement,
                                        )));
                          })
                    ],
                  );
                }),
              )),
          Positioned(
              top: 104,
              left: 20,
              child: Container(
                width: 351,
                height: 53,
                decoration: BoxDecoration(
                    color: offButtonColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: !isRecordActive ? () => toggleView() : null,
                      child: Container(
                          width: isRecordActive ? 173 : 153,
                          height: 41,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isRecordActive
                                  ? primaryColor
                                  : offButtonColor),
                          child: Text('기록하기',
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
                          width: !isRecordActive ? 173 : 153,
                          height: 41,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: !isRecordActive
                                  ? primaryColor
                                  : offButtonColor),
                          child: Text('기간별 조회',
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
            const BloodsugarRecord(), // showRecordView가 true인 경우 혈당 기록 페이지를 보여줌
          if (!isRecordActive)
            const BloodsugarView(), // showRecordView가 false인 경우 기간별 조회 페이지를 보여줌
        ],
      ),
    );
  }
}
