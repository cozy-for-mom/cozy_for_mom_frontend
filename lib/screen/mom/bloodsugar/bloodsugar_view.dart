import 'dart:math';

import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/time_line_chart_widget.dart';
import 'package:cozy_for_mom_frontend/model/bloodsugar_model.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_bloodsugar_api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmall = screenHeight < 670;
    final paddingValue = 20.w;
    BloodsugarApiService bloodsugarViewModel =
        Provider.of<BloodsugarApiService>(context, listen: true);
    Random random = Random();
    final randomIndex = random.nextInt(timeText.length);

    return Consumer<MyDataModel>(builder: (context, globalData, _) {
      return FutureBuilder(
          future: bloodsugarViewModel.getAvgBloodsugar(
            context,
            globalData.selectedDate,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              avg = snapshot.data!;
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
                  top: isSmall? 184.h : 204.h,
                  left: paddingValue,
                  child: const TimeLineChart(recordType: RecordType.bloodsugar),
                ),
                Positioned(
                    top: isSmall? 655.h : 635.h,
                    left: paddingValue,
                    child: Container(
                      width: screenWidth - 2 * paddingValue,
                      height: isSmall? 124.w : min(134.w, 214),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: isSmall? 14.h : 24.h),
                      decoration: BoxDecoration(
                          color: contentBoxTwoColor,
                          borderRadius: BorderRadius.circular(20.w)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('평균 $avg의 혈당 수치예요',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: min(18.sp, 28))),
                                Padding(padding: EdgeInsets.only(bottom: 6.h)),
                                Text.rich(
                                  TextSpan(
                                    text: '임산부의 ${timeText[randomIndex]} 혈당치는 ',
                                    style: TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: min(12.sp, 22)),
                                    children: [
                                      TextSpan(
                                          text:
                                              '평균 ${timeAvgBloodsugar[randomIndex]}mg/dL', // 고정값 - 평균 임산부 식후 혈당: 식후 1시간, 2시간 랜덤으로 보여주기
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(12.sp, 22))),
                                      TextSpan(
                                          text:
                                              '\n정도로 일반인보다 ${avg < timeAvgBloodsugar[randomIndex] ? '낮' : '높'}은 편이네요!',
                                          style: TextStyle(
                                              color: mainTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(12.sp, 22))),
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 8.h)),
                                InkWell(
                                    child: Text(
                                      '출처: 질병관리청 국가건강정보포털 (https://health.kdca.go.kr/)',
                                      style: TextStyle(
                                        color: const Color(
                                            0xff9397A4), // offButtonTextColor)
                                        fontSize: min(8.sp, 18),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          'https://health.kdca.go.kr/healthinfo/biz/health/ntcnInfo/healthSourc/thtimtCntnts/thtimtCntntsView.do?thtimt_cntnts_sn=61&utm_source=kdca&utm_medium=banner'));
                                    })
                              ],
                            ),
                            Image.asset(
                                'assets/images/icons/icon_bloodsugar.png',
                                width: min(47.w, 94),
                                height: min(61.w, 122)),
                          ]),
                    ))
              ],
            );
          });
    });
  }
}
