import 'dart:async';
import 'package:flutter/material.dart';

class DeleteCompleteAlertModal extends StatelessWidget {
  final String text;

  const DeleteCompleteAlertModal({Key? key, required this.text})
      : super(key: key);

  static void showDeleteCompleteDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        return DeleteCompleteAlertModal(text: text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // 여기에 필요한 UI를 구성
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * (1 / 3),
        height: 41,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          '${text} 삭제 되었습니다',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
