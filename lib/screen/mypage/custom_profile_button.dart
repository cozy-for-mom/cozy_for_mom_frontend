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
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                ),
              ),
            ),
            const SizedBox(height: 10),
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