import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class BabyDuedateInputScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const BabyDuedateInputScreen({super.key, required this.updateValidity});

  @override
  State<BabyDuedateInputScreen> createState() => _BabyDuedateInputScreenState();
}

class _BabyDuedateInputScreenState extends State<BabyDuedateInputScreen> {
  TextEditingController dueDateController = TextEditingController();
  TextEditingController lastMensesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    dueDateController.text = joinInputData.dueDate;
    lastMensesController.text = joinInputData.laseMensesDate;
    return Stack(
      children: [
        Positioned(
          top: AppUtils.scaleSize(context, 50),
          left: AppUtils.scaleSize(context, 20),
          child: Text('출산 예정일을 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppUtils.scaleSize(context, 26))),
        ),
        Positioned(
          top: AppUtils.scaleSize(context, 95),
          left: AppUtils.scaleSize(context, 20),
          child: Text('출산 예정일은 마이로그에서 수정할 수 있어요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: AppUtils.scaleSize(context, 14))),
        ),
        Positioned(
          top: AppUtils.scaleSize(context, 150),
          left: AppUtils.scaleSize(context, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('출산예정일',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scaleSize(context, 14))),
              SizedBox(height: AppUtils.scaleSize(context, 10)),
              Container(
                  width: screenWidth - AppUtils.scaleSize(context, 40),
                  height: AppUtils.scaleSize(context, 48),
                  padding: EdgeInsets.symmetric(
                      vertical: AppUtils.scaleSize(context, 10),
                      horizontal: AppUtils.scaleSize(context, 20)),
                  decoration: BoxDecoration(
                      color: contentBoxTwoColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: dueDateController,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 10,
                    cursorColor: primaryColor,
                    cursorHeight: AppUtils.scaleSize(context, 14),
                    cursorWidth: AppUtils.scaleSize(context, 1.2),
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: AppUtils.scaleSize(context, 14)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppUtils.scaleSize(context, 10)),
                      border: InputBorder.none,
                      hintText: 'YYYY.MM.DD',
                      hintStyle: TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w400,
                          fontSize: AppUtils.scaleSize(context, 14)),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          // TODO 자동완성 후, 지웠다가 다시 입력할때 자동완성 안됨
                          String parsedDate;
                          if (value.length == 8 && _isNumeric(value)) {
                            parsedDate = DateFormat('yyyy.MM.dd')
                                .format(DateTime.parse(value));
                          } else {
                            parsedDate = value;
                          }
                          joinInputData.dueDate = parsedDate;
                          widget.updateValidity(
                              dueDateController.text.isNotEmpty &
                                  lastMensesController.text.isNotEmpty);
                        });
                      }
                    },
                  )),
            ],
          ),
        ),
        Positioned(
          top: AppUtils.scaleSize(context, 254),
          left: AppUtils.scaleSize(context, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('마지막 월경 시작일',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scaleSize(context, 14))),
              SizedBox(height: AppUtils.scaleSize(context, 10)),
              Container(
                  width: screenWidth - AppUtils.scaleSize(context, 40),
                  height: AppUtils.scaleSize(context, 48),
                  padding: EdgeInsets.symmetric(
                      vertical: AppUtils.scaleSize(context, 10),
                      horizontal: AppUtils.scaleSize(context, 20)),
                  decoration: BoxDecoration(
                      color: contentBoxTwoColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: lastMensesController,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 10,
                    cursorColor: primaryColor,
                    cursorHeight: AppUtils.scaleSize(context, 14),
                    cursorWidth: AppUtils.scaleSize(context, 1.2),
                    style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: AppUtils.scaleSize(context, 14)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppUtils.scaleSize(context, 10)),
                      border: InputBorder.none,
                      hintText: 'YYYY.MM.DD',
                      hintStyle: TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w400,
                          fontSize: AppUtils.scaleSize(context, 14)),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          String parsedDate;
                          if (value.length == 8 && _isNumeric(value)) {
                            parsedDate = DateFormat('yyyy.MM.dd')
                                .format(DateTime.parse(value));
                          } else {
                            parsedDate = value;
                          }
                          joinInputData.laseMensesDate = parsedDate;
                          widget.updateValidity(
                              dueDateController.text.isNotEmpty &
                                  lastMensesController.text.isNotEmpty);
                        });
                      }
                    },
                  )),
            ],
          ),
        )
      ],
    );
  }
}

bool _isNumeric(String value) {
  final numericRegex = RegExp(r'^[0-9]+$');
  return numericRegex.hasMatch(value);
}
