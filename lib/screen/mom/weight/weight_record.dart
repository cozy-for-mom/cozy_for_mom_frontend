import 'package:cozy_for_mom_frontend/model/weight_model.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/time_line_chart_widget.dart';
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
  bool _isWeightInitialized = false;
  DateTime _lastCheckedDate = DateTime.now(); // 마지막으로 데이터를 로드한 날짜

  // 데이터 로딩 로직을 처리합니다.
  void _initializeData(DateTime selectedDate) {
    if (!_isWeightInitialized || _lastCheckedDate != selectedDate) {
      _lastCheckedDate = selectedDate; // 현재 처리 날짜를 업데이트
      print('gg $selectedDate . $todayWeight');
      // 데이터 로드 및 초기화 로직
      if (todayWeight > 0) {
        _weightController.text = todayWeight.toString();
      } else {
        if (pregnantWeights.isNotEmpty) {
          _weightController.text = pregnantWeights.first.weight.toString();
        } else {
          _weightController.clear();
        }
      }
      _isWeightInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData(Provider.of<MyDataModel>(context, listen: true)
          .selectedDate); // 초기 데이터 로드
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    WeightApiService momWeightViewModel =
        Provider.of<WeightApiService>(context, listen: true);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<MyDataModel>(builder: (context, globalData, _) {
          Future.delayed(Duration.zero, () {
            if (_lastCheckedDate != globalData.selectedDate) {
              _initializeData(globalData.selectedDate);
            }
          });
          print('! ${globalData.selectedDate} . ${_weightController.text}');
          return FutureBuilder(
              future: momWeightViewModel.getWeights(globalData.selectedDate,
                  'daily'), // TODO daily/weekly/monthly 지정
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  data = snapshot.data!;
                  todayWeight = data['todayWeight'];
                  pregnantWeights = data['weights'] ?? [];
                  lastRecordDate = data['lastRecordDate'] == ''
                      ? const Duration(days: -1) // TODO default value
                      : DateTime.now()
                          .difference(DateTime.parse(data['lastRecordDate']));
                  _isInitialized = todayWeight > 0 ? true : false;
                  // print('--------------------------------');

                  // pregnantWeights.map((data) {
                  //   print('${data.dateTime} ${data.weight}');
                  // }).toList();
                  // print('--------------------------------');
                  // print('!! ${_weightController.text}');
                }
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: primaryColor,
                    color: Colors.white,
                  ));
                }
                return Stack(
                  children: [
                    Positioned(
                        top: 47,
                        width: screenWidth,
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
                                          backgroundColor: Colors.transparent,
                                          elevation: 0.0,
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
                            )
                            // }),
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
                                    Text(
                                        lastRecordDate ==
                                                const Duration(days: -1)
                                            ? '측정 기록이 없어요'
                                            : '마지막 측정 ${lastRecordDate.inDays}일전',
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
                                        cursorWidth: 1,
                                        cursorHeight: 28,
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
                                                  : beforeInputColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 28,
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            if (text.isNotEmpty) {
                                              if (text.length ==
                                                      5 && // 입력 형식을 따르지 않았을 경우, 디폴트 값 지정
                                                  !text.contains('.')) {
                                                _weightController.text =
                                                    '999.9';
                                              }
                                            }
                                          });
                                        },
                                        onFieldSubmitted: (value) async {
                                          _isInitialized
                                              ? await momWeightViewModel
                                                  .modifyWeight(
                                                      globalData.selectedDate,
                                                      double.parse(value))
                                              : await momWeightViewModel
                                                  .recordWeight(
                                                      globalData.selectedDate,
                                                      double.parse(value));
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Text(
                                      'kg',
                                      style: TextStyle(
                                          color:
                                              _weightController.text.isNotEmpty
                                                  ? afterInputColor
                                                  : beforeInputColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 28),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 331,
                      left: 20,
                      child: TimeLineChart(
                        recordType: RecordType.weight,
                      ),
                    ),
                  ],
                );
              });
        }));
  }
}
