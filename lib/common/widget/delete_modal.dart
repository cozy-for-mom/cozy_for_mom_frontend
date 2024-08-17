import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/complite_alert.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        width: screenWidth,
        height: AppUtils.scaleSize(context, 173),
        decoration: BoxDecoration(
            color: contentBoxTwoColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppUtils.scaleSize(context, 30),
                  horizontal: AppUtils.scaleSize(context, 20)),
              child: Text(widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scaleSize(context, 16))),
            ),
            Container(
                width: screenWidth, height: 1, color: const Color(0xffD9D9D9)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: AppUtils.scaleSize(context, 56),
                    child: Text('취소',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: AppUtils.scaleSize(context, 14))),
                  ),
                ),
                Container(
                    width: 1,
                    height: AppUtils.scaleSize(context, 65),
                    color: const Color(0xffD9D9D9)),
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
                    width: AppUtils.scaleSize(context, 56),
                    alignment: Alignment.center,
                    child: Text('삭제하기',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: AppUtils.scaleSize(context, 14))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
