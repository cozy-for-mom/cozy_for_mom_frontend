import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_complite_alert.dart';

class DeleteModal extends StatefulWidget {
  final String text;
  final String title;
  final VoidCallback? tapFunc;

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
        width: screenWidth, // TODO 화면 너비에 맞춘 width로 수정해야함
        height: 173,
        decoration: BoxDecoration(
            color: contentBoxTwoColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Text(widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: mainTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16)),
            ),
            Container(
                width: 350,
                height: 1,
                color: const Color(0xffD9D9D9)), // TODO 화면 너비에 맞춘 width로 수정해야함
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 56,
                    child: const Text('취소',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ),
                Container(width: 1, height: 65, color: const Color(0xffD9D9D9)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.tapFunc?.call();
                    DeleteCompleteAlertModal.showDeleteCompleteDialog(
                        context, widget.title);
                  },
                  child: Container(
                    width: 56,
                    alignment: Alignment.center,
                    child: const Text('삭제하기',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
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
