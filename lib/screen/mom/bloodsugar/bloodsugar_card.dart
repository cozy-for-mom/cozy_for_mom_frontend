import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/mom/bloodsugar/bloodsugar_modal.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_bloodsugar_api_service.dart';
import 'package:cozy_for_mom_frontend/model/bloodsugar_model.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';

class BloodsugarCard extends StatefulWidget {
  final String time;

  BloodsugarCard({super.key, required this.time});
  @override
  State<BloodsugarCard> createState() => _BloodsugarCardState();
}

class _BloodsugarCardState extends State<BloodsugarCard> {
  final List<String> periods = ['식전', '식후'];
  late BloodsugarApiService momBloodsugarViewModel;
  late Map<String, dynamic> data;
  late String type;
  late List<PregnantBloosdugar> pregnantBloodsugars;
  late int bloodsugarId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    BloodsugarApiService momBloodsugarViewModel =
        Provider.of<BloodsugarApiService>(context, listen: true);

    return Consumer<MyDataModel>(builder: (context, globalData, _) {
      return FutureBuilder(
          future: momBloodsugarViewModel.getBloodsugars(
              context, globalData.selectedDate),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              pregnantBloodsugars = snapshot.data! as List<PregnantBloosdugar>;
            }
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: primaryColor,
                color: Colors.white,
              ));
            }
            return Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.w)),
              child: Container(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 20.w, bottom: 12.w),
                width: screenWidth - 2 * paddingValue,
                height: min(160.w, 250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.time,
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: min(12.sp, 22)),
                    ),
                    Column(
                        children: periods.map((period) {
                      String input = pregnantBloodsugars.any((bloodsugar) =>
                              bloodsugar.type == '${widget.time} $period')
                          ? pregnantBloodsugars
                              .firstWhere((bloodsugar) =>
                                  bloodsugar.type == '${widget.time} $period')
                              .level
                              .toString()
                          : '-';
                      int id = pregnantBloodsugars.any((bloodsugar) =>
                              bloodsugar.type == '${widget.time} $period')
                          ? pregnantBloodsugars
                              .firstWhere((bloodsugar) =>
                                  bloodsugar.type == '${widget.time} $period')
                              .id
                          : -1;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(period,
                                  style: TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: min(16.sp, 26))),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      input == '-'
                                          ? showDialog(
                                              context: context,
                                              builder: (context) {
                                                return BloodsugarModal(
                                                  time: widget.time,
                                                  period: period,
                                                  bloodsugarValue: '',
                                                );
                                              },
                                            ).then((updatedData) {
                                              if (updatedData != null) {
                                                setState(() {
                                                  bloodsugarId = updatedData;
                                                });
                                              }
                                            })
                                          : showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0.0,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SelectBottomModal(
                                                    selec1: '기록 수정하기',
                                                    selec2: '기록 삭제하기',
                                                    tap1: () {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return BloodsugarModal(
                                                            time: widget.time,
                                                            period: period,
                                                            id: id,
                                                            bloodsugarValue:
                                                                input,
                                                          );
                                                        },
                                                      ).then((updatedData) {
                                                        if (updatedData !=
                                                            null) {
                                                          setState(() {
                                                            bloodsugarId =
                                                                updatedData;
                                                          });
                                                        }
                                                      });
                                                    },
                                                    tap2: () {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (context) {
                                                            return DeleteModal(
                                                                text:
                                                                    '등록된 기록을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                                title: '기록이',
                                                                tapFunc:
                                                                    () async {
                                                                  await momBloodsugarViewModel
                                                                      .deleteBloodsugar(
                                                                          context,
                                                                          id);
                                                                  setState(
                                                                      () {});
                                                                });
                                                          });
                                                    });
                                              });
                                    },
                                    child: Container(
                                      width: min(130.w, 230),
                                      height: min(41.w, 61),
                                      decoration: BoxDecoration(
                                          color: input == '-'
                                              ? offButtonColor
                                              : primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20.w)),
                                      child: Center(
                                        child: Text(input,
                                            textAlign: TextAlign.center,
                                            style: input == '-'
                                                ? TextStyle(
                                                    color: mainTextColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: min(18.sp, 28))
                                                : TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: min(16.sp, 26))),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 8.w),
                                      child: Text(
                                        'mg / dL',
                                        style: TextStyle(
                                            color: mainTextColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: min(14.sp, 24)),
                                      )),
                                ],
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 8.h)),
                        ],
                      );
                    }).toList()),
                  ],
                ),
              ),
            );
          });
    });
  }
}
