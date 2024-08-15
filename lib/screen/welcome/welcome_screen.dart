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
      body: Column(
        children: [
          SizedBox(
            height: AppUtils.scaleSize(context, 70),
          ),
          Image(
            height: AppUtils.scaleSize(context, 395),
            image: const AssetImage(
              "assets/images/welcome_image.png",
            ),
            fit: BoxFit.fitHeight,
          ),
          const Text(
            "W   E   L   C   O   M   E",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: AppUtils.scaleSize(context, 15),
          ),
          const Text(
            "현명한 임신 준비\n코지포맘에서 시작해요",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              height: 1.4,
            ),
          ),
          SizedBox(
            height: AppUtils.scaleSize(context, 25),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "아기도, 엄마도 건강한 ",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff5E6573),
                ),
              ),
              Text(
                "건강 기록 관리",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E6573),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppUtils.scaleSize(context, 10),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "잊지않고 건강을 챙길 수 있는 ",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff5E6573),
                ),
              ),
              Text(
                "포맘 알림",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E6573),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppUtils.scaleSize(context, 10),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "산모들의 소통창구 ",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff5E6573),
                ),
              ),
              Text(
                "코지로그 커뮤니티",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E6573),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppUtils.scaleSize(context, 90),
          ),
          Container(
            width: screenWidth - AppUtils.scaleSize(context, 40),
            height: AppUtils.scaleSize(context, 56),
            padding: EdgeInsets.symmetric(
                vertical: AppUtils.scaleSize(context, 18),
                horizontal: AppUtils.scaleSize(context, 50)),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext buildContext) {
                //     return const NotificationCheckModal();
                //   },
                // );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen()));
              },
              child: const Text(
                '시작하기',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

void main(List<String> args) {
  runApp(const MaterialApp(
    home: WelcomeScreen(),
  ));
}
