import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

// 아이콘 + 텍스트 버튼 (커스텀버튼 위젯)
class CustomTextButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final void Function() onPressed;

  CustomTextButton({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 24, // 이미지 너비 조정
              height: 24, // 이미지 높이 조정
            ),
            const SizedBox(height: 10), // 이미지와 텍스트 사이 여백
            Text(
              text,
              style: const TextStyle(
                  color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
