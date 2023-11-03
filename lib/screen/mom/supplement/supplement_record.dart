import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/supplement_model.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_card.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';

class SupplementRecord extends StatefulWidget {
  const SupplementRecord({Key? key}) : super(key: key);

  @override
  State<SupplementRecord> createState() => _SupplementRecordState();
}

class _SupplementRecordState extends State<SupplementRecord> {
  List<PregnantSupplement> supplements = [
    PregnantSupplement(
        supplementName: '철분제', targetCount: 2, realCount: 0, takeTimes: []),
    PregnantSupplement(
        supplementName: '비타민B', targetCount: 3, realCount: 0, takeTimes: []),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // 현재 날짜
    String formattedDate = DateFormat('M.d E', 'ko_KR').format(now);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 47,
            width: 400, // TODO 화면 너비에 맞춘 width로 수정해야함
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
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
                        Text(formattedDate,
                            style: const TextStyle(
                                color: Color(0xff2B2D35),
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                        IconButton(
                          alignment: AlignmentDirectional.centerStart,
                          icon: const Icon(Icons.expand_more),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white
                                  .withOpacity(0.0), // 팝업창 자체 색 : 투명
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        height: 20,
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
                                          iconSize: 20,
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // 팝업 닫기
                                          },
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          color: const Color(0xffFAFAFA),
                                          padding: const EdgeInsets.only(
                                              top: 20,
                                              bottom: 40,
                                              left: 20,
                                              right: 20),
                                          width:
                                              400, // TODO 화면 너비에 맞춘 width로 수정해야함
                                          height:
                                              500, // TODO 화면 높이에 맞춘 height로 수정해야함
                                          child: const MonthCalendar(),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    IconButton(
                        icon: const Image(
                            image: AssetImage('assets/images/icons/alert.png'),
                            height: 32,
                            width: 32),
                        onPressed: () {
                          print(
                              '알림창 아이콘 클릭'); // TODO 알림창 아이콘 onPressed{} 구현해야 함
                        })
                  ]),
            ),
          ),
          Positioned(
              top: 102,
              left: 20,
              child: Container(
                width: 350,
                height: 63,
                decoration: const BoxDecoration(
                    color: Colors.white60), // TODO 주간 캘린더 위젯 넣어야 함
                child: const Center(
                    child: Text(
                  '주간 캘린더',
                  style: TextStyle(fontSize: 20),
                )),
              )),
          Positioned(
            top: 203,
            left: 20,
            child: Column(
              children: supplements.map((supplement) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: supplementCard(
                      name: supplement.supplementName,
                      targetCount: supplement.targetCount,
                      realCount: supplement.realCount,
                      takeTimes: supplement.takeTimes,
                    ));
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: const CustomFloatingButton(),
    );
  }
}
