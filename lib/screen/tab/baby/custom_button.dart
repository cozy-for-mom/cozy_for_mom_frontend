import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String imagePath;
  const CustomButton({super.key, required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.scaleSize(context, 170),
      height: AppUtils.scaleSize(context, 80),
      decoration: BoxDecoration(
          color: contentBoxColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(text,
              style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scaleSize(context, 14))),
          Image(
              image: AssetImage(imagePath),
              width: AppUtils.scaleSize(context, 31),
              height: AppUtils.scaleSize(context, 31))
        ],
      ),
    );
  }
}
