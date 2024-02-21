import 'package:cozy_for_mom_frontend/model/weight_model.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/time_line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/service/mom_weight_api_service.dart';
import 'package:provider/provider.dart';

class WeightRecord extends StatefulWidget {
  const WeightRecord({super.key});

  @override
  State<WeightRecord> createState() => _WeightRecordState();
}

class _WeightRecordState extends State<WeightRecord> {
  late WeightApiService momWeightViewModel;
  late Map<String, dynamic> data;
  late double todayWeight;
  late List<PregnantWeight> pregnantWeights;
  final TextEditingController _weightController = TextEditingController();
  // 포커스 관리 (사용자가 특정 위젯에 포커스를 주거나 포커스를 뺄 때 이벤트를 처리)
  final FocusNode _weightFocus = FocusNode();
  Color unitTextColor = const Color(0xffE0E0E0);
  bool _isInitialized = false;

  // 메모리 누수 방지 _ 메모리 해제에 사용되는 메서드 (자동호출)
  @override
  void dispose() {
    _weightController.dispose();
    _weightFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WeightApiService momWeightViewModel =
        Provider.of<WeightApiService>(context, listen: true);
    DateTime now = DateTime.now(); // 현재 날짜
    String formattedDate = DateFormat('M.d E', 'ko_KR').format(now);
    return FutureBuilder(
        future: momWeightViewModel.getWeights(now, 'daily'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            data = snapshot.data!;
            todayWeight = data['todayWeight'];
            pregnantWeights = data['weights'] ?? [];
            if (!_isInitialized) {
              _weightController.text = todayWeight.toString();
              _isInitialized = true;
            }
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent, // 로딩화면(circle)
            ));
          }
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
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
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
                                  image: AssetImage(
                                      'assets/images/icons/alert.png'),
                                  height: 32,
                                  width: 32),
                              onPressed: () {
                                print(
                                    '알림창 아이콘 클릭'); // TODO 알림창 아이콘 onPressed{} 구현해야 함
                              })
                        ]),
                  ),
                ),
                const Positioned(
                    top: 103,
                    left: 20,
                    child: SizedBox(
                      height: 100,
                      width: 350,
                      child: WeeklyCalendar(),
                    )),
                Positioned(
                  top: 205,
                  left: 20,
                  child: Container(
                    width: 350, // TODO 화면 너비에 맞춘 width로 수정해야함
                    height: 86,
                    decoration: BoxDecoration(
                        color: contentBoxTwoColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('나의 체중',
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18)),
                                Text('마지막 측정 3일전',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 105,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    maxLength: 6,
                                    showCursor: false,
                                    controller: _weightController,
                                    focusNode: _weightFocus,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        border: InputBorder.none,
                                        counterText: '',
                                        hintText: '00.00',
                                        hintStyle: TextStyle(
                                          color: beforeInputColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 28,
                                        )),
                                    style: TextStyle(
                                      color: _weightController.text ==
                                              todayWeight.toString()
                                          ? afterInputColor
                                          : unitTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28,
                                    ),
                                    onChanged: (text) {
                                      setState(() {
                                        if (text.isNotEmpty) {
                                          unitTextColor = afterInputColor;
                                        } else {
                                          unitTextColor = beforeInputColor;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  'kg',
                                  style: TextStyle(
                                      color: _weightController.text ==
                                              todayWeight.toString()
                                          ? afterInputColor
                                          : unitTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  top: 331,
                  left: 20,
                  child: TimeLineChart(
                    recordType: RecordType.weight,
                    dataList: [
                      if (data['weights'] != null)
                        ...(pregnantWeights.map((data) {
                          final formattedDate =
                              '${data.dateTime.substring(5, 7)}.${data.dateTime.substring(8)}';
                          return LineChartData(formattedDate, data.weight);
                        }).toList())
                    ],
                    // dataList: [
                    //   LineChartData("05.11", 55),
                    //   LineChartData("05.15", 52),
                    //   LineChartData("05.17", 55),
                    //   LineChartData("05.22", 60),
                    // ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
