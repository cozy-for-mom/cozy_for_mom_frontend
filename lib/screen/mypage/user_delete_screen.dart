import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/user_delete_modal.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class UserDeleteScreen extends StatefulWidget {
  const UserDeleteScreen({super.key});

  @override
  State<UserDeleteScreen> createState() => _UserDeleteScreenState();
}

class _UserDeleteScreenState extends State<UserDeleteScreen> {
  final deletedReasons = [
    "아기가 찾아오면 다시 올게요.",
    "원하는 기능이 없어요.",
    "사용을 잘 안하게 돼요.",
    "새 계정을 만들고 싶어요.",
    "기타",
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Container(),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: min(28.w, 38),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: paddingValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "코지포맘",
                  style: TextStyle(
                    fontSize: min(26.sp, 36),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "탈퇴 사유를 알려주세요.",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: min(26.sp, 36),
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Text(
                  "회원 탈퇴 사유를 알려주세요. 추후 서비스 개선에 중요한\n자료로 참고하겠습니다.",
                  style: TextStyle(
                    color: const Color(0xff8C909E),
                    fontWeight: FontWeight.w500,
                    fontSize: min(14.sp, 24),
                  ),
                ),
                SizedBox(
                  height: min(40.w, 50),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: deletedReasons.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: min(8.w, 12),
                        ),
                        child: Container(
                          height: min(48.w, 88),
                          decoration: BoxDecoration(
                            color: const Color(0xffF7F7FA),
                            borderRadius: BorderRadius.circular(10.w),
                            border: selectedIndex == index
                                ? Border.all(
                                    color: primaryColor,
                                    width: 2.w,
                                  )
                                : null,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (selectedIndex == index) {
                                setState(() {
                                  selectedIndex = null;
                                });
                              } else {
                                setState(() {
                                  selectedIndex = index;
                                });
                              }
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.w, horizontal: min(20.w, 30)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: selectedIndex == index
                                          ? primaryColor
                                          : const Color(0xffD9D9D9),
                                      size: min(18.w, 28),
                                      weight: 5.w,
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Text(
                                      deletedReasons[index],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: selectedIndex == index
                                            ? Colors.black
                                            : const Color(0xff858998),
                                        fontWeight: FontWeight.w400,
                                        fontSize: min(14.sp, 24),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
                  if (selectedIndex != null) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext buildContext) {
                        return UserDeleteModal(
                            reason: deletedReasons[selectedIndex!]);
                      },
                    );
                  }
                },
                child: Container(
                  height: min(56.w, 96),
                  margin: EdgeInsets.symmetric(
                    horizontal: paddingValue,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: selectedIndex == null
                          ? const Color(0xffC2C4CB)
                          : Colors.black,
                      borderRadius: BorderRadius.circular(12.w)),
                  child: Text(
                    "회원 탈퇴",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: min(16.sp, 26),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
