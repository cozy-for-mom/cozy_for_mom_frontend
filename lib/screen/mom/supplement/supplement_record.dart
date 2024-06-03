import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/model/supplement_model.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_card.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_register_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_supplement_api_service.dart';

import 'package:provider/provider.dart';

class SupplementRecord extends StatefulWidget {
  const SupplementRecord({Key? key}) : super(key: key);

  @override
  State<SupplementRecord> createState() => _SupplementRecordState();
}

class _SupplementRecordState extends State<SupplementRecord> {
  late SupplementApiService momSupplementViewModel;
  late List<PregnantSupplement> pregnantSupplements;

  @override
  Widget build(BuildContext context) {
    SupplementApiService momSupplementViewModel =
        Provider.of<SupplementApiService>(context, listen: true);
    DateTime now = DateTime.now(); // 현재 날짜
    String formattedDate = DateFormat('M.d E', 'ko_KR').format(now);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final supplementNameController = TextEditingController();
    final supplementTargetCountController = TextEditingController();

    return FutureBuilder(
        // TODO 캘린더 연동 (선택한 날짜로 API 요청하도록 수정)
        future: momSupplementViewModel.getSupplements(now),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pregnantSupplements = snapshot.data! as List<PregnantSupplement>;
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AlarmSettingPage(
                                                type: CardType.supplement,
                                              )));
                                })
                          ]),
                    ),
                  ),
                  const Positioned(
                    top: 120,
                    left: 20,
                    child: SizedBox(
                      height: 100,
                      width: 350,
                      child: WeeklyCalendar(),
                    ),
                  ),
                  Positioned(
                    top: 203,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: pregnantSupplements.isEmpty
                          ? [
                              SizedBox(
                                  height: screenHeight * (0.55),
                                  child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                            image: AssetImage(
                                                'assets/images/icons/supplement_off.png'),
                                            width: 28,
                                            height: 67.2),
                                        Text('영양제를 등록해 보세요!',
                                            style: TextStyle(
                                                color: Color(0xff9397A4),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                      ])),
                            ]
                          : pregnantSupplements.map((supplement) {
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: SupplementCard(
                                    supplementId: supplement.supplementId,
                                    name: supplement.supplementName,
                                    targetCount: supplement.targetCount,
                                    realCount: supplement.realCount,
                                    takeTimes: supplement.records
                                        .map((record) => record.datetime)
                                        .toList(),
                                    recordIds: supplement.records
                                        .map((record) => record.id)
                                        .toList(),
                                  ));
                            }).toList(),
                    ),
                  ),
                ],
              ),
              floatingActionButton: CustomFloatingButton(pressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SupplementRegisterModal();
                  },
                );
              }));
        });
  }
}
