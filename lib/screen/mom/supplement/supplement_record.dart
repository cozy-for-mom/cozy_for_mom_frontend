import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/weekly_calendar.dart';
import 'package:cozy_for_mom_frontend/model/supplement_model.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_card.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_register_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
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
  late List<int> supplementIds;
  late List<DateTime> supplementIntakes = [];

  @override
  Widget build(BuildContext context) {
    SupplementApiService momSupplementViewModel =
        Provider.of<SupplementApiService>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    void addSupplement(int id) {
      setState(() {
        supplementIds.add(id);
      });
    }

    void updateSupplementIntake(DateTime newData) {
      setState(() {
        supplementIntakes.remove;
        supplementIntakes.add(newData);
      });
    }

    void deleteSupplement(int id) {
      setState(() {
        supplementIds.remove(id);
      });
    }

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<MyDataModel>(
          builder: (context, globalData, _) {
            return FutureBuilder(
                future: momSupplementViewModel.getSupplements(
                    context, globalData.selectedDay),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    pregnantSupplements =
                        snapshot.data! as List<PregnantSupplement>;
                    supplementIds = pregnantSupplements
                        .map((supplement) => supplement.supplementId)
                        .toList();
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
                          top: isTablet ? 0.w : 50.w,
                          width: screenWidth,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: paddingValue - 20.w,
                                  bottom: paddingValue - 20.w,
                                  right: 8.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Image(
                                      image: const AssetImage(
                                          'assets/images/icons/back_ios.png'),
                                      width: min(34.w, 44),
                                      height: min(34.w, 44),
                                      color: mainTextColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  SizedBox(
                                    width: min(30.w, 40),
                                    height: min(30.w, 40),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('M.d E', 'ko_KR')
                                            .format(globalData.selectedDate),
                                        style: TextStyle(
                                          color: mainTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: min(18.sp, 28),
                                        ),
                                      ),
                                      IconButton(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        icon: const Icon(Icons.expand_more),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                elevation: 0.0,
                                context: context,
                                builder: (context) {
                                  return Wrap(children : [MonthCalendarModal(limitToday: true)]);
                                },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      icon: Image(
                                        image: const AssetImage(
                                            'assets/images/icons/alert.png'),
                                        height: min(32.w, 42),
                                        width: min(32.w, 42),
                                      ),
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
                              ))),
                      Positioned(
                        top: isTablet? 80.h : 110.h,
                        left: paddingValue,
                        child: SizedBox(
                          width: screenWidth - 2 * paddingValue,
                          child: const WeeklyCalendar(),
                        ),
                      ),
                      Positioned(
                        top: 200.h,
                        left: paddingValue,
                        right: paddingValue,
                        child: pregnantSupplements.isEmpty
                            ? SizedBox(
                                height: screenHeight * (0.55),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          image: const AssetImage(
                                              'assets/images/icons/supplement_off.png'),
                                          width: min(28.w, 56),
                                          height: min(67.2.w, 134.4)),
                                      Text('영양제를 등록해 보세요!',
                                          style: TextStyle(
                                              color: const Color(0xff9397A4),
                                              fontWeight: FontWeight.w500,
                                              fontSize: min(14.sp, 24))),
                                    ]))
                            : SizedBox(
                                height: screenHeight,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (0.3)),
                                    child: Column(
                                      children:
                                          pregnantSupplements.map((supplement) {
                                        return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10.w),
                                            child: SupplementCard(
                                              supplementId:
                                                  supplement.supplementId,
                                              name: supplement.supplementName,
                                              targetCount:
                                                  supplement.targetCount,
                                              realCount: supplement.realCount,
                                              takeTimes: supplement.records
                                                  .map((record) =>
                                                      record.datetime)
                                                  .toList(),
                                              recordIds: supplement.records
                                                  .map((record) => record.id)
                                                  .toList(),
                                              onDelete: deleteSupplement,
                                              onUpdate: (updatedData) =>
                                                  updateSupplementIntake(
                                                      updatedData),
                                            ));
                                      }).toList(),
                                      
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  );
                });
          },
        ),
        floatingActionButton: CustomFloatingButton(pressed: () {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return SupplementRegisterModal(
                onRegister: addSupplement,
              );
            },
          );
        }));
  }
}
