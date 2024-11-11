import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/complite_alert.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteModal extends StatefulWidget {
  final String text;
  final String title;
  final Future<void> Function()? tapFunc;

  const DeleteModal(
      {super.key, required this.text, required this.title, this.tapFunc});
  @override
  State<DeleteModal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<DeleteModal> {
  List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        width: screenWidth - 2 * paddingValue,
        height: min(173.w, 273),
        decoration: BoxDecoration(
            color: contentBoxTwoColor,
            borderRadius: BorderRadius.circular(20.w)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 50.w - paddingValue),
              child: Text(widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: min(16.sp, 26))),
            ),
             Container(
                  width: screenWidth,
                  height: 1.w,
                  color: const Color(0xffD9D9D9)),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 100.w,
                        child: Text('취소',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: min(14.sp, 24))),
                      ),
                    ),
                    Container(width: 1.w, color: const Color(0xffD9D9D9)),
                    InkWell(
                      onTap: () async {
                        await widget.tapFunc!();
                        if (mounted) {
                          Navigator.of(context).pop(true);
                          await CompleteAlertModal.showCompleteDialog(
                              context, widget.title, '삭제');
                        }
                      },
                      child: Container(
                        width: 100.w,
                        alignment: Alignment.center,
                        child: Text('삭제하기',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: min(14.sp, 24))),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
