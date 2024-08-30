import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/welcome/notification_check_modal.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: AppUtils.scaleSize(context, 70),
              ),
              Image(
                height: AppUtils.scaleSize(context, 390),
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
                  fontSize: AppUtils.scaleSize(context, 10),
                ),
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 15),
              ),
              Text(
                "현명한 임신 준비\n코지포맘에서 시작해요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: AppUtils.scaleSize(context, 30),
                  height: AppUtils.scaleSize(context, 1.4),
                ),
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 25),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "아기도, 엄마도 건강한 ",
                    style: TextStyle(
                        fontSize: AppUtils.scaleSize(context, 14),
                        color: const Color(0xff5E6573),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "건강 기록 관리",
                    style: TextStyle(
                      fontSize: AppUtils.scaleSize(context, 14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff5E6573),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "잊지않고 건강을 챙길 수 있는 ",
                    style: TextStyle(
                        fontSize: AppUtils.scaleSize(context, 14),
                        color: const Color(0xff5E6573),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "포맘 알림",
                    style: TextStyle(
                      fontSize: AppUtils.scaleSize(context, 14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff5E6573),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "산모들의 소통창구 ",
                    style: TextStyle(
                        fontSize: AppUtils.scaleSize(context, 14),
                        color: const Color(0xff5E6573),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "코지로그 커뮤니티",
                    style: TextStyle(
                      fontSize: AppUtils.scaleSize(context, 14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff5E6573),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
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
                  top: AppUtils.scaleSize(context, 20),
                  bottom: AppUtils.scaleSize(context, 34),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  },
                  child: Container(
                    height: AppUtils.scaleSize(context, 56),
                    margin: EdgeInsets.symmetric(
                        horizontal: AppUtils.scaleSize(context, 20)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: primaryColor),
                    child: Center(
                      child: Text(
                        '시작하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppUtils.scaleSize(context, 16),
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
