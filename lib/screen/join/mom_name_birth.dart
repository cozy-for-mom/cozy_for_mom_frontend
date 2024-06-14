import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';

class MomNameBirthInputScreen extends StatefulWidget {
  const MomNameBirthInputScreen({super.key});

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
        const Positioned(
          top: 50,
          left: 20,
          child: Text('산모님에 대해 알려주세요',
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        const Positioned(
          top: 95,
          left: 20,
          child: Text('안심하세요! 개인정보는 외부에 공개되지 않아요.',
              style: TextStyle(
                  color: offButtonTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ),
        Positioned(
          top: 150,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('이름',
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
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                      hintText: '이름을 입력해주세요',
                      hintStyle: TextStyle(
                          color: beforeInputColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        joinInputData.setName(value);
                      });
                    },
                  )),
            ],
          ),
        ),
        Positioned(
          top: 254,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('생년월일',
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
                    controller: birthController,
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
                        String parsedDate;
                        if (value.length == 8) {
                          parsedDate = DateFormat('yyyy.MM.dd')
                              .format(DateTime.parse(value));
                        } else {
                          parsedDate = value;
                        }
                        joinInputData.birth = parsedDate;
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
