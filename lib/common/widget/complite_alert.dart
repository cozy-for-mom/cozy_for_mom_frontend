import 'dart:async';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CompleteAlertModal extends StatelessWidget {
  final String text;
  final String action;

  const CompleteAlertModal({Key? key, required this.text, required this.action})
      : super(key: key);

  static Future<void> showCompleteDialog(
      BuildContext context, String text, String action) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        return CompleteAlertModal(text: text, action: action);
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
        height: AppUtils.scaleSize(context, 41),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          '${text} ${action} 되었습니다',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: AppUtils.scaleSize(context, 16)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
