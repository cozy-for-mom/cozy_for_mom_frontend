import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class DeleteModal extends StatefulWidget {
  const DeleteModal({super.key});

  @override
  State<DeleteModal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<DeleteModal> {
  List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        width: 350, // TODO 화면 너비에 맞춘 width로 수정해야함
        height: 173,
        decoration: BoxDecoration(
            color: contentBoxTwoColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Text('등록된 데이터는 다시 복구할 수 없습니다.\n삭제하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                    print('삭제하기 버튼 클릭'); // TODO 삭제하기 버튼 기능 구현
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
