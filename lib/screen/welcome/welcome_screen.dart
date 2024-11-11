import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: isTablet? 0.w : 70.w,
              ),
              Image(
                height: isTablet? 300.w : 390.w,
                image: const AssetImage(
                  "assets/images/welcome_image.png",
                ),
                fit: BoxFit.fitHeight,
              ),
              Text(
                "W   E   L   C   O   M   E",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: min(10.sp, 20),
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "현명한 임신 준비\n코지포맘에서 시작해요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: min(30.sp, 40),
                ),
              ),
              SizedBox(
                height: 20.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "아기도, 엄마도 건강한 ",
                    style: TextStyle(
                        fontSize: min(14.sp, 24),
                        color: const Color(0xff5E6573),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "건강 기록 관리",
                    style: TextStyle(
                      fontSize: min(14.sp, 24),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff5E6573),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "잊지않고 건강을 챙길 수 있는 ",
                    style: TextStyle(
                        fontSize: min(14.sp, 24),
                        color: const Color(0xff5E6573),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "포맘 알림",
                    style: TextStyle(
                      fontSize: min(14.sp, 24),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff5E6573),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "산모들의 소통창구 ",
                    style: TextStyle(
                        fontSize: min(14.sp, 24),
                        color: const Color(0xff5E6573),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "코지로그 커뮤니티",
                    style: TextStyle(
                      fontSize: min(14.sp, 24),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff5E6573),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 0.h,
              left: 0.w,
              right: 0.w,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 20.w,
                  bottom: 54.w - paddingValue,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  },
                  child: Container(
                    height: min(56.w, 96),
                    margin: EdgeInsets.symmetric(horizontal: paddingValue),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.w),
                        color: primaryColor),
                    child: Center(
                      child: Text(
                        '시작하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: min(16.sp, 26),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
