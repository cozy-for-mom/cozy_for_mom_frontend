import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class MomEmailInputScreen extends StatefulWidget {
  const MomEmailInputScreen({super.key});

  @override
  State<MomEmailInputScreen> createState() => _MomEmailInputScreenState();
}

class _MomEmailInputScreenState extends State<MomEmailInputScreen> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final joinInputData = Provider.of<JoinInputData>(context);
    textController.text = joinInputData.email;
    return Stack(
      children: [
        const Positioned(
          top: 50,
          left: 20,
          child: Text('사용할 이메일을 입력해 주세요',
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
          top: 180,
          left: 20,
          child: Container(
              width: screenWidth - 40,
              height: 48,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: contentBoxTwoColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                readOnly: true,
                controller: textController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              )),
        ),
      ],
    );
  }
}
