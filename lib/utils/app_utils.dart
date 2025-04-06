import 'package:flutter/material.dart';

class AppUtils {
  static double scaleSize(BuildContext context, double w) {
    var screenWidth = MediaQuery.of(context).size.width;
    return w * (screenWidth / 390); // 390는 디자인 기준 width
  }
}
