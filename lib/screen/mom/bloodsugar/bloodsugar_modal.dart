import 'package:cozy_for_mom_frontend/model/bloodsugar_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_bloodsugar_api_service.dart';

class BloodsugarModal extends StatefulWidget {
  final String time;
  final String period;
  final int id;
  final String bloodsugarValue;

  BloodsugarModal(
      {super.key,
      required this.time,
      required this.period,
      this.id = 0,
      required this.bloodsugarValue});

  @override
  State<BloodsugarModal> createState() => _BloodsugarModalState();
}

class _BloodsugarModalState extends State<BloodsugarModal> {
  bool _isHintVisible = true;
  late List<PregnantBloosdugar> pregnantBloodsugars;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = widget.bloodsugarValue;
    // BloodsugarApiService momBloodsugarViewModel =
    //     Provider.of<BloodsugarApiService>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final globalData = Provider.of<MyDataModel>(context,
        listen: false); // record -> false 초기화, modify -> true 초기화
    ValueNotifier<bool> isButtonEnabled =
        ValueNotifier<bool>(widget.bloodsugarValue != '');
    BloodsugarApiService bloodsugarApi = BloodsugarApiService();
    // return Consumer<MyDataModel>(builder: (context, globalData, _) {
    //   return FutureBuilder(
    //       future:
    //           momBloodsugarViewModel.getBloodsugars(globalData.selectedDate),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           pregnantBloodsugars = snapshot.data! as List<PregnantBloosdugar>;
    //           textController.text = pregnantBloodsugars.any((bloodsugar) =>
    //                   bloodsugar.type == '${widget.time} ${widget.period}')
    //               ? pregnantBloodsugars
    //                   .firstWhere((bloodsugar) =>
    //                       bloodsugar.type == '${widget.time} ${widget.period}')
    //                   .level
    //                   .toString()
    //               : '';
    //         }
    //         if (!snapshot.hasData) {
    //           return const Center(
    //               child: CircularProgressIndicator(
    //             backgroundColor: primaryColor,
    //             color: Colors.white,
    //           ));
    //         }
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth - AppUtils.scaleSize(context, 40),
            height: AppUtils.scaleSize(context, 207),
            padding: EdgeInsets.symmetric(
                horizontal: AppUtils.scaleSize(context, 20)),
            decoration: BoxDecoration(
              color: contentBoxTwoColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('혈당 기록',
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppUtils.scaleSize(context, 20))),
                Container(
                  width: AppUtils.scaleSize(context, 312),
                  height: AppUtils.scaleSize(context, 80),
                  padding: EdgeInsets.only(
                      left: AppUtils.scaleSize(context, 24),
                      right: AppUtils.scaleSize(context, 24),
                      top: AppUtils.scaleSize(context, 12)),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          child: Text(widget.time,
                              style: TextStyle(
                                  color: offButtonTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppUtils.scaleSize(context, 12))),
                        ),
                        SizedBox(
                          height: AppUtils.scaleSize(context, 32),
                          child: TextFormField(
                            controller: textController,
                            onChanged: (text) {
                              if (text.isEmpty) {
                                isButtonEnabled.value = false; // 입력값이 없을 때
                              } else {
                                isButtonEnabled.value = true; // 입력값이 있을 때
                              }
                            },
                            maxLength: 3,
                            textAlign: TextAlign.start,
                            cursorWidth: AppUtils.scaleSize(context, 0.8),
                            cursorHeight: AppUtils.scaleSize(context, 15),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                suffixText: 'mg / dL',
                                suffixStyle: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppUtils.scaleSize(context, 14)),
                                hintText: _isHintVisible ? 'mg / dL' : null,
                                hintStyle: TextStyle(
                                    color: beforeInputColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppUtils.scaleSize(context, 16))),
                            cursorColor: primaryColor,
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: AppUtils.scaleSize(context, 16)),
                            onTap: () {
                              setState(() {
                                _isHintVisible = false;
                              });
                            },
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          SizedBox(height: AppUtils.scaleSize(context, 18)),
          ValueListenableBuilder<bool>(
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return Container(
                  width: screenWidth - AppUtils.scaleSize(context, 40),
                  height: AppUtils.scaleSize(context, 56),
                  padding: EdgeInsets.symmetric(
                      vertical: AppUtils.scaleSize(context, 18),
                      horizontal: AppUtils.scaleSize(context, 50)),
                  decoration: BoxDecoration(
                      color: isEnabled ? primaryColor : const Color(0xffC9DFF9),
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () async {
                      if (isEnabled) {
                        late int bloodsugarId;
                        widget.id > 0
                            ? bloodsugarId =
                                await bloodsugarApi.modifyBloodsugar(
                                    context,
                                    widget.id,
                                    globalData.selectedDate,
                                    '${widget.time} ${widget.period}',
                                    int.parse(textController.text))
                            : bloodsugarId =
                                await bloodsugarApi.recordBloodsugar(
                                    context,
                                    globalData.selectedDate,
                                    '${widget.time} ${widget.period}',
                                    int.parse(textController.text));
                        setState(() {
                          Navigator.pop(context, bloodsugarId);
                        });
                      }
                    },
                    child: Text(
                      '등록하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppUtils.scaleSize(context, 16)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
    //       });
    // });
  }
}
