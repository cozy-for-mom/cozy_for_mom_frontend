import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

// 공통으로 사용할 플로팅버튼
// TODO 버튼 클릭 시 실행해야할 함수를 파라미터로 받아야할 듯!

class CustomFloatingButton extends StatelessWidget {
  void Function()? pressed;

  CustomFloatingButton({
    this.pressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppUtils.scaleSize(context, 50),
      height: AppUtils.scaleSize(context, 50),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: primaryColor,
        onPressed: pressed,
        child: Image.asset(
          'assets/images/icons/plus_white.png',
          width: AppUtils.scaleSize(context, 24),
          height: AppUtils.scaleSize(context, 24),
        ),
      ),
    );
  }
}
