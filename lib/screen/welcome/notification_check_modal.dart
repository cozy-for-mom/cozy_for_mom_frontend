import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';

class NotificationCheckModal extends StatefulWidget {
  const NotificationCheckModal({super.key});

  @override
  State<NotificationCheckModal> createState() => _NotificationCheckModalState();
}

class _NotificationCheckModalState extends State<NotificationCheckModal> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      child: Container(
        width: screenWidth - AppUtils.scaleSize(context, 40),
        height: AppUtils.scaleSize(context, 220),
        decoration: BoxDecoration(
          color: contentBoxTwoColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: AppUtils.scaleSize(context, 30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "코지포맘 회원님을 위한 이벤트와\n혜택 알림을 받아보시겠어요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: AppUtils.scaleSize(context, 1.5),
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scaleSize(context, 16),
                ),
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 15),
              ),
              Text(
                "마케팅 푸시 허용 시, 산모에게 유용한 정보와\n이벤트, 혜택 정보를 받아보실 수 있어요.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  color: const Color(0xff9397A4),
                  fontSize: AppUtils.scaleSize(context, 13),
                ),
              ),
              SizedBox(
                height: AppUtils.scaleSize(context, 20),
              ),
              Column(
                children: [
                  Divider(
                    thickness: 1,
                    color: const Color(
                      0xffD9D9D9,
                    ),
                    height: AppUtils.scaleSize(context, 2),
                  ),
                  Row(
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
                          width: AppUtils.scaleSize(context, 56),
                          child: Text(
                            '허용 안 함',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppUtils.scaleSize(context, 14),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: AppUtils.scaleSize(context, 60),
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
                          width: AppUtils.scaleSize(context, 56),
                          alignment: Alignment.center,
                          child: Text(
                            '허용',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppUtils.scaleSize(context, 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
