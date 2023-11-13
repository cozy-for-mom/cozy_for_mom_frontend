import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';

// 공통으로 사용할 플로팅버튼

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomFloatingButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      onPressed: onTap,
      child: Image.asset(
        'assets/images/icons/plus_white.png', // 사용할 이미지 파일의 경로
        width: 24, // 이미지의 가로 크기
        height: 24, // 이미지의 세로 크기
      ),
    );
  }
}
