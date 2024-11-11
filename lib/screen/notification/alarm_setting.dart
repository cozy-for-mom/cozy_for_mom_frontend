import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/notification/notification_setting_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/notification/bloodsugar_alarm.dart';
import 'package:cozy_for_mom_frontend/screen/notification/supplement_alarm.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';

enum CardType { bloodsugar, supplement }

class AlarmSettingPage extends StatefulWidget {
  final CardType type;
  const AlarmSettingPage({super.key, required this.type});

  @override
  State<AlarmSettingPage> createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends State<AlarmSettingPage> {
  late CardType type = widget.type;

  List<int> notificationIds = [];
  bool isBloodSugarButtonEnabled = false;
  bool isSupplementButtonEnabled = false;
  String keyForUpdate = DateTime.now().toString(); // 갱신을 위한 키

  void registerNotification(int id) {
    setState(() {
      notificationIds.add(id);
      keyForUpdate = DateTime.now().toString();
    });
  }

  @override
  void initState() {
    super.initState();
    // 초기에 전달받은 타입에 따라 버튼 상태 초기화
    switch (widget.type) {
      case CardType.bloodsugar:
        isBloodSugarButtonEnabled = true;
        break;
      case CardType.supplement:
        isSupplementButtonEnabled = true;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7FA),
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          "알림 설정",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: min(18.sp, 28)),
        ),
        leading: IconButton(
          icon: Image(
            image: const AssetImage('assets/images/icons/back_ios.png'),
            width: min(34.w, 44),
            height: min(34.w, 44),
            color: mainTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
              top: isTablet? 20.h : 5.h,
              left: paddingValue,
              child: Container(
                width: screenWidth - 2 * paddingValue,
                height: min(53.w, 93),
                decoration: BoxDecoration(
                    color: offButtonColor,
                    borderRadius: BorderRadius.circular(30.w)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = CardType.bloodsugar;
                          isBloodSugarButtonEnabled = true;
                          isSupplementButtonEnabled = false;
                        });
                      },
                      child: Container(
                          width: isBloodSugarButtonEnabled
                              ? 193.w - paddingValue
                              : 173.w - paddingValue,
                          height: min(41.w, 71),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.w),
                              color: isBloodSugarButtonEnabled
                                  ? primaryColor
                                  : offButtonColor),
                          child: Center(
                            child: Text('혈당',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isBloodSugarButtonEnabled
                                      ? Colors.white
                                      : offButtonTextColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: min(16.sp, 26),
                                )),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = CardType.supplement;
                          isBloodSugarButtonEnabled = false;
                          isSupplementButtonEnabled = true;
                        });
                      },
                      child: Container(
                          width: isSupplementButtonEnabled
                              ? 193.w - paddingValue
                              : 173.w - paddingValue,
                          height: min(41.w, 71),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.w),
                              color: isSupplementButtonEnabled
                                  ? primaryColor
                                  : offButtonColor),
                          child: Center(
                            child: Text('영양제',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSupplementButtonEnabled
                                      ? Colors.white
                                      : offButtonTextColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: min(16.sp, 26),
                                )),
                          )),
                    ),
                  ],
                ),
              )),
          isBloodSugarButtonEnabled
              ? BloodsugarAlarm(key: ValueKey(keyForUpdate))
              : SupplementAlarm(key: ValueKey(keyForUpdate)),
        ],
      ),
      floatingActionButton: CustomFloatingButton(
        pressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationSettingScreen(
                type: type,
                onRegister: registerNotification,
              ),
            ),
          );
        },
      ),
    );
  }
}
