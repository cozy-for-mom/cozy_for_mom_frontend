import 'package:cozy_for_mom_frontend/model/weight_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/time_line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
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
  late double todayWeight = 0;
  late Duration lastRecordDate;
  late List<PregnantWeight> pregnantWeights = [];
  late bool _isInitialized;
  final TextEditingController _weightController = TextEditingController();
  String _previousInput = '';

  bool _isWeightInitialized = false;
  DateTime _lastCheckedDate = DateTime.now(); // 마지막으로 데이터를 로드한 날짜

  Future<void> _initializeData(DateTime selectedDate) async {
    if (!_isWeightInitialized || _lastCheckedDate != selectedDate) {
      _lastCheckedDate = selectedDate; // 현재 처리 날짜를 업데이트
      if (todayWeight > 0) {
        // 체중 기록 있는 경우
        _weightController.text = todayWeight.toString();
      } else {
        if (pregnantWeights.isNotEmpty) {
          // 현재 날짜에 대한 기록 없지만 이전 날짜 기록 있는 경우
          _weightController.text = pregnantWeights.first.weight.toString();
        } else {
          _weightController.clear();
        }
      }
      _isWeightInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    WeightApiService momWeightViewModel =
        Provider.of<WeightApiService>(context, listen: false);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<MyDataModel>(builder: (context, globalData, _) {
          return FutureBuilder(
              future: momWeightViewModel.getWeights(
                  context,
                  globalData.selectedDate,
                  'daily'), // 조회 그래프가 아닌 선택한 날짜의 체중값을 위헤 호출하는 것이므로 daily로 픽스한다.
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // 비동기 작업이 완전히 완료되었는지 확인하는 조건
                  if (snapshot.hasData) {
                    data = snapshot.data!;
                    todayWeight = data['todayWeight'];
                    pregnantWeights = data['weightList'] ?? [];
                    lastRecordDate = data['lastRecordDate'] == ''
                        ? const Duration(days: -1) // TODO default value
                        : DateTime.now()
                            .difference(DateTime.parse(data['lastRecordDate']));
                    _isInitialized = todayWeight > 0 ? true : false;
                    _initializeData(globalData.selectedDate);
                  }
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
                        top: AppUtils.scaleSize(context, 47),
                        width: screenWidth,
                        child: Padding(
                            padding:
                                EdgeInsets.all(AppUtils.scaleSize(context, 10)),
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
                                      style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            AppUtils.scaleSize(context, 20),
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
                                            return MonthCalendarModal(
                                              limitToday: true,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                IconButton(
                                    icon: Image(
                                        image: const AssetImage(
                                            'assets/images/icons/alert.png'),
                                        height: AppUtils.scaleSize(context, 32),
                                        width: AppUtils.scaleSize(context, 32)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AlarmSettingPage(
                                                    type: CardType.bloodsugar,
                                                  )));
                                    })
                              ],
                            )
                            // }),
                            )),
                    Positioned(
                        top: AppUtils.scaleSize(context, 103),
                        left: AppUtils.scaleSize(context, 20),
                        child: SizedBox(
                          height: AppUtils.scaleSize(context, 100),
                          width: screenWidth - AppUtils.scaleSize(context, 40),
                          child: const WeeklyCalendar(),
                        )),
                    Positioned(
                      top: AppUtils.scaleSize(context, 205),
                      left: AppUtils.scaleSize(context, 20),
                      child: Container(
                        width: screenWidth - AppUtils.scaleSize(context, 40),
                        height: AppUtils.scaleSize(context, 86),
                        decoration: BoxDecoration(
                            color: contentBoxTwoColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding:
                              EdgeInsets.all(AppUtils.scaleSize(context, 20)),
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
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: AppUtils.scaleSize(
                                                context, 12))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: AppUtils.scaleSize(context, 105),
                                      child: TextFormField(
                                        textAlign: TextAlign.end,
                                        maxLength: 5,
                                        controller: _weightController,
                                        // keyboardType: const TextInputType
                                        //     .numberWithOptions(decimal: true), // TODO 완료 버튼 따로 추가하면 바꾸기
                                        keyboardType: TextInputType.datetime,
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        textInputAction: TextInputAction.done,
                                        cursorColor: primaryColor,
                                        cursorWidth:
                                            AppUtils.scaleSize(context, 1),
                                        cursorHeight:
                                            AppUtils.scaleSize(context, 28),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical:
                                                        AppUtils.scaleSize(
                                                            context, 7)),
                                            border: InputBorder.none,
                                            counterText: '',
                                            hintText: '00.00',
                                            hintStyle: TextStyle(
                                              color: beforeInputColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: AppUtils.scaleSize(
                                                  context, 28),
                                            )),
                                        style: TextStyle(
                                          color:
                                              _weightController.text.isNotEmpty
                                                  ? afterInputColor
                                                  : beforeInputColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              AppUtils.scaleSize(context, 28),
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
                                              if ((text.contains('.') &&
                                                      text.indexOf('.') !=
                                                          text.lastIndexOf(
                                                              '.')) ||
                                                  (!RegExp(r'^\d*\.?\d*$')
                                                      .hasMatch(text))) {
                                                _weightController.text =
                                                    text.substring(
                                                        0, text.length - 1);
                                              }
                                            }
                                          });
                                        },

                                        onFieldSubmitted: (value) async {
                                          _isInitialized
                                              ? await momWeightViewModel
                                                  .modifyWeight(
                                                      context,
                                                      globalData.selectedDate,
                                                      double.parse(value))
                                              : await momWeightViewModel
                                                  .recordWeight(
                                                      context,
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
                                          fontSize:
                                              AppUtils.scaleSize(context, 28)),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppUtils.scaleSize(context, 331),
                      left: AppUtils.scaleSize(context, 20),
                      child: const TimeLineChart(
                        recordType: RecordType.weight,
                      ),
                    ),
                  ],
                );
              });
        }));
  }
}
