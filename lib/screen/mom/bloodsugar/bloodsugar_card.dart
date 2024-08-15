import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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
    BloodsugarApiService momBloodsugarViewModel =
        Provider.of<BloodsugarApiService>(context, listen: true);
    return Consumer<MyDataModel>(builder: (context, globalData, _) {
      return FutureBuilder(
          future:
              momBloodsugarViewModel.getBloodsugars(globalData.selectedDate),
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
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                padding: EdgeInsets.only(
                    left: AppUtils.scaleSize(context, 20),
                    right: AppUtils.scaleSize(context, 20),
                    top: AppUtils.scaleSize(context, 20),
                    bottom: AppUtils.scaleSize(context, 12)),
                width: screenWidth - AppUtils.scaleSize(context, 40),
                height: AppUtils.scaleSize(context, 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.time,
                      style: const TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
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
                                  style: const TextStyle(
                                      color: mainTextColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
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
                                              backgroundColor:
                                                  Colors.transparent,
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
                                                                          id);
                                                                  setState(
                                                                      () {});
                                                                });
                                                          });
                                                    });
                                              });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppUtils.scaleSize(context, 50),
                                          vertical:
                                              AppUtils.scaleSize(context, 10)),
                                      width: AppUtils.scaleSize(context, 130),
                                      height: AppUtils.scaleSize(context, 41),
                                      decoration: BoxDecoration(
                                          color: input == '-'
                                              ? offButtonColor
                                              : primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(input,
                                          textAlign: TextAlign.center,
                                          style: input == '-'
                                              ? const TextStyle(
                                                  color: mainTextColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18)
                                              : const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: AppUtils.scaleSize(context, 8)),
                                      child: const Text(
                                        'mg / dL',
                                        style: TextStyle(
                                            color: mainTextColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      )),
                                ],
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: AppUtils.scaleSize(context, 8))),
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
