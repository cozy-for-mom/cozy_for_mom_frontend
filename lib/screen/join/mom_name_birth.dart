import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class MomNameBirthInputScreen extends StatefulWidget {
  final Function(bool) updateValidity;
  const MomNameBirthInputScreen({super.key, required this.updateValidity});

  @override
  State<MomNameBirthInputScreen> createState() =>
      _MomNameBirthInputScreenState();
}

class _MomNameBirthInputScreenState extends State<MomNameBirthInputScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    nameController.text = joinInputData.name;
    birthController.text = joinInputData.birth;
    return Stack(
      children: [
        Positioned(
          top: AppUtils.scaleSize(context, 50),
          left: AppUtils.scaleSize(context, 20),
          child: const Text('산모님에 대해 알려주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        Positioned(
          top: AppUtils.scaleSize(context, 95),
          left: AppUtils.scaleSize(context, 20),
          child: const Text('안심하세요! 개인정보는 외부에 공개되지 않아요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ),
        Positioned(
          top: AppUtils.scaleSize(context, 150),
          left: AppUtils.scaleSize(context, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('이름',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
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
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 24,
                    cursorColor: primaryColor,
                    cursorHeight: 14,
                    cursorWidth: 1.2,
                    style: const TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppUtils.scaleSize(context, 10)),
                      border: InputBorder.none,
                      hintText: '이름을 입력해주세요',
                      hintStyle: const TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          joinInputData.setName(value);
                        });
                      }
                      widget.updateValidity(nameController.text.isNotEmpty &
                          birthController.text.isNotEmpty);
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
              const Text('생년월일',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
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
                    controller: birthController,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 10,
                    cursorColor: primaryColor,
                    cursorHeight: 14,
                    cursorWidth: 1.2,
                    style: const TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppUtils.scaleSize(context, 10)),
                      border: InputBorder.none,
                      hintText: 'YYYY.MM.DD',
                      hintStyle: const TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
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
                          joinInputData.birth = parsedDate;
                          widget.updateValidity(nameController.text.isNotEmpty &
                              birthController.text.isNotEmpty);
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
