import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/time_line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/common/widget/line_chart_widget.dart';

class BloodsugarView extends StatelessWidget {
  const BloodsugarView({super.key});

  final double avg = 109.0; // TODO 그래프 범위 맞춰 평균치 계산해줘야 함
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 204,
          left: 20,
          child: TimeLineChart(
            recordType: RecordType.bloodsugar,
            dataList: [
              LineChartData("05.11", 45),
              LineChartData("05.12", 47),
              LineChartData("05.13", 47),
              LineChartData("05.15", 50),
            ],
          ),
        ),
        // child: Container(
        //   width: 350,
        //   height: 399,
        //   decoration: const BoxDecoration(
        //       color: Colors.white60,
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(20),
        //           topRight: Radius.circular(20))),
        // )),
        Positioned(
            top: 635,
            left: 20,
            child: Container(
              width: 350,
              height: 114,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                        Text('평균 ${avg}의 혈당 수치예요',
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                        const Padding(padding: EdgeInsets.only(bottom: 6)),
                        const Text.rich(
                          TextSpan(
                            text: '임산부의 혈당치는 공복시 ',
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                            children: [
                              TextSpan(
                                  text:
                                      '평균 77mg/dL', // TODO 고정되어있는 값인지 다시 확인해봐야 함
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                              TextSpan(
                                  text: ' 정도로 \n일반인보다 낮은 편이네요!',
                                  style: TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                        'assets/images/icons/icon_bloodsugar.png', // TODO 아이콘 디자인이 바껴서 잘리는 문제 해결되면 원래 있던 이미지 파일 지우고 동일한 이름으로 다시 다운받아야 함
                        width: 47,
                        height: 61),
                  ]),
            ))
      ],
    );
  }
}
