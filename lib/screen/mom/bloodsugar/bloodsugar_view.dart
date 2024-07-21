import 'dart:math';

import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/time_line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/model/bloodsugar_model.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_bloodsugar_api_service.dart';
import 'package:provider/provider.dart';

class BloodsugarView extends StatefulWidget {
  const BloodsugarView({super.key});

  @override
  State<BloodsugarView> createState() => _BloodsugarViewState();
}

class _BloodsugarViewState extends State<BloodsugarView> {
  late double avg; // TODO 응답데이터에서 받아오는 값
  final timeText = ['식후 1시간', '식후 2시간'];
  final timeAvgBloodsugar = [120, 105];
  late BloodsugarApiService bloodsugarViewModel;
  late int data;
  late String type;
  late List<BloodsugarPerPeriod> bloodsugars;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    BloodsugarApiService bloodsugarViewModel =
        Provider.of<BloodsugarApiService>(context, listen: true);
    Random random = Random();
    final randomIndex = random.nextInt(timeText.length);

    return Consumer<MyDataModel>(builder: (context, globalData, _) {
      return FutureBuilder(
          future: bloodsugarViewModel.getAvgBloodsugar(
            globalData.selectedDate,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              avg = snapshot.data!;
              print(avg);
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
                const Positioned(
                  top: 204,
                  left: 20,
                  child: TimeLineChart(recordType: RecordType.bloodsugar),
                ),
                Positioned(
                    top: 635,
                    left: 20,
                    child: Container(
                      width: screenWidth - 40,
                      height: 114,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                          color: contentBoxTwoColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('평균 $avg의 혈당 수치예요',
                                    style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18)),
                                const Padding(
                                    padding: EdgeInsets.only(bottom: 6)),
                                Text.rich(
                                  TextSpan(
                                    text: '임산부의 ${timeText[randomIndex]} 혈당치는 ',
                                    style: const TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                    children: [
                                      TextSpan(
                                          text:
                                              '평균 ${timeAvgBloodsugar[randomIndex]}mg/dL', // 고정값 - 평균 임산부 식후 혈당: 식후 1시간, 2시간 랜덤으로 보여주기
                                          style: const TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12)),
                                      TextSpan(
                                          text:
                                              '\n정도로 일반인보다 ${avg < timeAvgBloodsugar[randomIndex] ? '낮' : '높'}은 편이네요!',
                                          style: const TextStyle(
                                              color: mainTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                                'assets/images/icons/icon_bloodsugar.png',
                                width: 47,
                                height: 61),
                          ]),
                    ))
              ],
            );
          });
    });
  }
}
