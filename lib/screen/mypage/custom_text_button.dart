import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

// 아이콘 + 텍스트 버튼 (커스텀버튼 위젯)
class CustomTextButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final FontWeight textWeight;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final void Function() onPressed;

  CustomTextButton({
    required this.text,
    required this.textColor,
    required this.textWeight,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(AppUtils.scaleSize(context, 10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageWidth,
              height: imageHeight,
            ),
            SizedBox(height: AppUtils.scaleSize(context, 10)),
            Text(
              text,
              style: TextStyle(
                  color: textColor, fontWeight: textWeight, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
