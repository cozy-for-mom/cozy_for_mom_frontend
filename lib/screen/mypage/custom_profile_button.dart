import 'package:flutter/material.dart';

class CustomProfileButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool isSelected;
  final void Function() onPressed;

  CustomProfileButton({
    required this.text,
    required this.imagePath,
    required this.isSelected,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: isSelected
                      ? Border.all(width: 2, color: const Color(0xff5CA6F8))
                      : null,
                  color: isSelected
                      ? const Color(0xffDCEDFF)
                      : const Color(0xffF8F8FA)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  imagePath,
                  width: 40, // 이미지 너비 조정
                  height: 40, // 이미지 높이 조정
                  alignment: Alignment.center,
                ),
              ),
            ),
            const SizedBox(height: 10), // 이미지와 텍스트 사이 여백
            Text(
              text,
              style: TextStyle(
                  color: isSelected
                      ? const Color(0xff5CA6F8)
                      : const Color(0xff858998),
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
