import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/login/login_screen.dart';
import 'package:cozy_for_mom_frontend/service/user/join_api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class UserDeleteModal extends StatefulWidget {
  final String reason;
  const UserDeleteModal({super.key, required this.reason});

  @override
  State<UserDeleteModal> createState() => UserDeleteModalState();
}

class UserDeleteModalState extends State<UserDeleteModal> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Dialog(
      child: Container(
        width: screenWidth - 2 * paddingValue,
        height: min(220.w, 400),
        decoration: BoxDecoration(
          color: contentBoxTwoColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: 25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "정말 코지포맘 계정을\n삭제하시겠어요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: min(1.5.w, 1.5),
                  fontWeight: FontWeight.w600,
                  fontSize: min(18.sp, 28),
                ),
              ),
              SizedBox(
                height: 15.w,
              ),
              Text(
                "회원을 탈퇴하면 모든 데이터가 소멸돼요.\n추후 같은 회원 정보일지라도 복구되지 않습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: min(1.5.w, 1.5),
                  color: const Color(0xff9397A4),
                  fontWeight: FontWeight.w500,
                  fontSize: min(14.sp, 24),
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
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 56.w,
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: min(16.sp, 26),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1.w, color: const Color(0xffD9D9D9)),
                    InkWell(
                      onTap: () async {
                        await JoinApiService().signOut(context, widget.reason);
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (Route<dynamic> route) => false, // 모든 이전 화면을 제거
                          );
                        }
                      },
                      child: Container(
                        width: 56.w,
                        alignment: Alignment.center,
                        child: Text(
                          '탈퇴',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: min(16.sp, 26),
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
