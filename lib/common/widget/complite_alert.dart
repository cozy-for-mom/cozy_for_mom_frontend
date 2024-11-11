import 'dart:async';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * (0.45),
        height: 41.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.circular(10.w)),
        child: Text(
          '${text} ${action}되었습니다.',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: min(16.sp, 26)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
