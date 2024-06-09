import 'package:cozy_for_mom_frontend/model/weight_model.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/time_line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_weight_api_service.dart';
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
  late Duration lastRecordDate;
  late List<PregnantWeight> pregnantWeights;
  late bool _isInitialized;
  final TextEditingController _weightController = TextEditingController();
  Color unitTextColor = beforeInputColor;

// 메모리 누수 방지 _ 메모리 해제에 사용되는 메서드 (자동호출)
  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    WeightApiService momWeightViewModel =
        Provider.of<WeightApiService>(context, listen: true);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<MyDataModel>(builder: (context, globalData, _) {
          _isInitialized = false;
          return FutureBuilder(
              future: momWeightViewModel.getWeights(
                  globalData.selectedDate, 'daily'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  data = snapshot.data!;
                  todayWeight = data['todayWeight'];
                  // print('--------tw--------- $todayWeight');
                  print(_isInitialized);
                  pregnantWeights = data['weights'] ?? [];
                  lastRecordDate = DateTime.now()
                      .difference(DateTime.parse(data['lastRecordDate']));
                  if (!_isInitialized &&
                      todayWeight > 0 &&
                      _weightController.text != todayWeight.toString()) {
                    _weightController.text = todayWeight.toString();
                    _isInitialized = true;
                  }
                  print('wt ${_weightController.text} tw $todayWeight');
                  // print(_weightController.text);

                  // print('--------wt--------- ${_weightController.text}');
                }
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent, // 로딩화면(circle)
                  ));
                }
                return Stack(
                  children: [
                    Positioned(
                        top: 47,
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Consumer<MyDataModel>(
                              builder: (context, globalData, _) {
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
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      icon: const Icon(Icons.expand_more),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          backgroundColor:
                                              contentBoxTwoColor.withOpacity(
                                                  0.0), // 팝업창 자체 색 : 투명
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
                        width: screenWidth - 40,
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
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('나의 체중',
                                        style: TextStyle(
                                            color: mainTextColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18)),
                                    Text('마지막 측정 ${lastRecordDate.inDays}일전',
                                        style: const TextStyle(
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
                                        maxLength: 5,
                                        controller: _weightController,
                                        keyboardType: TextInputType.number,
                                        cursorColor: primaryColor,
                                        cursorWidth: 0.8,
                                        cursorHeight: 26,
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 7),
                                            border: InputBorder.none,
                                            counterText: '',
                                            hintText: '00.00',
                                            hintStyle: TextStyle(
                                              color: beforeInputColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 28,
                                            )),
                                        style: TextStyle(
                                          color:
                                              _weightController.text.isNotEmpty
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
                                        onFieldSubmitted: (value) {
                                          _isInitialized
                                              ? momWeightViewModel.modifyWeight(
                                                  globalData.selectedDate,
                                                  double.parse(value))
                                              : momWeightViewModel.recordWeight(
                                                  globalData.selectedDate,
                                                  double.parse(value));
                                        },
                                      ),
                                    ),
                                    Text(
                                      'kg',
                                      style: TextStyle(
                                          color:
                                              _weightController.text.isNotEmpty
                                                  // todayWeight.toString()
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
                      ),
                    ),
                  ],
                );
              });
        }));
  }
}
