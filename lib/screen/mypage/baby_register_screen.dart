import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BabyRegisterScreen extends StatefulWidget {
  const BabyRegisterScreen({super.key});

  @override
  State<BabyRegisterScreen> createState() => _BabyRegisterScreenState();
}

const labelTextColor = Color(0xff858998);

class _BabyRegisterScreenState extends State<BabyRegisterScreen> {
  String? gender = "아직 모르겠어요";
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: Container(),
          actions: [
            IconButton(
                color: Colors.black,
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // 현재 화면을 닫음
                }),
          ]),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        image?.path ?? 'assets/images/icons/babyProfile.png',
                        fit: BoxFit.contain, // 이미지를 화면에 맞게 조절
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                      ),
                    ),
                    Positioned(
                      left: 206,
                      top: 72,
                      child: GestureDetector(
                        onTap: () async {
                          final selectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            image = selectedImage;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffA9ABB7),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 210,
                      top: 76,
                      child: GestureDetector(
                        onTap: () async {
                          final selectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            image = selectedImage;
                          });
                        },
                        child: Image.asset(
                          'assets/images/icons/pen.png',
                          fit: BoxFit.contain, // 이미지를 화면에 맞게 조절
                          width: 14,
                          height: 14,
                          color: Colors.white,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "출산예정일",
                  style: TextStyle(
                    color: labelTextColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: TextFormField(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          context: context,
                          builder: (context) {
                            return const MonthCalendarModal();
                          },
                        );
                      },
                      readOnly: true,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        hintText: "YYYY.MM.DD",
                        hintStyle: TextStyle(
                          color: Color(0xffE1E1E7),
                        ),
                        hoverColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "태명",
                  style: TextStyle(
                    color: labelTextColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: TextFormField(
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        hintText: "태명을 입력해주세요",
                        hintStyle: TextStyle(
                          color: Color(0xffE1E1E7),
                        ),
                        hoverColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "성별",
                  style: TextStyle(
                    color: labelTextColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: DropdownButton<String>(
                      // 옵션 설정할 떄 밑으로 두도록 수정해야함
                      alignment: AlignmentDirectional.bottomEnd,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xff858998),
                      ),
                      isExpanded: true,
                      focusColor: Colors.white,
                      value: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(), // meaningless
                      items: <String>[
                        '남아',
                        '여아',
                        '아직 모르겠어요',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: labelTextColor),
                          ),
                        );
                      }).toList(),
                      hint: const Text(
                        "아직 모르겠어요.",
                        style: TextStyle(
                          color: labelTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 350,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: primaryColor,
              ),
              child: const Center(
                child: Text(
                  "등록하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
