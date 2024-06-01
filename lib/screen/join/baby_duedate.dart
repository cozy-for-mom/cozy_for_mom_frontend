import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class BabyDuedateInputScreen extends StatefulWidget {
  const BabyDuedateInputScreen({super.key});

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
        const Positioned(
          top: 90,
          left: 20,
          child: Text('출산 예정일을 입력해주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 135,
          left: 20,
          child: Text('출산 예정일은 마이로그에서 수정할 수 있어요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ),
        Positioned(
          top: 190,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('출산예정일',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const SizedBox(height: 10),
              Container(
                  width: screenWidth - 40,
                  height: 48,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: contentBoxTwoColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: dueDateController,
                    keyboardType: TextInputType.datetime,
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
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                      hintText: 'YYYY.MM.DD',
                      hintStyle: TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        joinInputData.setDueDate(value);
                      });
                    },
                  )),
            ],
          ),
        ),
        Positioned(
          top: 294,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('마지막 월경 시작일',
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const SizedBox(height: 10),
              Container(
                  width: screenWidth - 40,
                  height: 48,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: contentBoxTwoColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: lastMensesController,
                    keyboardType: TextInputType.datetime,
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
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                      hintText: 'YYYY.MM.DD',
                      hintStyle: TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        joinInputData.laseMensesDate = value;
                      });
                    },
                  )),
            ],
          ),
        )
      ],
    );
  }
}
