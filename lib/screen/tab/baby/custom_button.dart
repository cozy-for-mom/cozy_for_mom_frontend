import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String imagePath;
  const CustomButton({super.key, required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 80,
      decoration: BoxDecoration(
          color: contentBoxColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(text,
              style: const TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          Image(image: AssetImage(imagePath), width: 31, height: 31)
        ],
      ),
    );
  }
}
