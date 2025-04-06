import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCheckModal extends StatefulWidget {
  const NotificationCheckModal({super.key});

  @override
  State<NotificationCheckModal> createState() => _NotificationCheckModalState();
}

class _NotificationCheckModalState extends State<NotificationCheckModal> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Dialog(
      child: Container(
        width: screenWidth - 2 * paddingValue,
        height: min(210.w, 390),
        decoration: BoxDecoration(
          color: contentBoxTwoColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 25.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "코지포맘 회원님을 위한 이벤트와\n혜택 알림을 받아보시겠어요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: min(16.sp, 26),
                ),
              ),
              SizedBox(
                height: 15.w,
              ),
              Text(
                "마케팅 푸시 허용 시, 산모에게 유용한 정보와\n이벤트, 혜택 정보를 받아보실 수 있어요.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff9397A4),
                  fontWeight: FontWeight.w500,
                  fontSize: min(13.sp, 23),
                ),
              ),
              SizedBox(
                height: 20.w,
              ),
              Container(
                  width: screenWidth,
                  height: 1.w,
                  color: const Color(0xffD9D9D9)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        print('허용 not api call?');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 100.w,
                        child: Text(
                          '허용 안 함',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: min(14.sp, 24),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.w,
                      color: const Color(0xffD9D9D9),
                    ),
                    InkWell(
                      onTap: () {
                        print('허용 api call?');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 100.w,
                        alignment: Alignment.center,
                        child: Text(
                          '허용',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: min(14.sp, 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
