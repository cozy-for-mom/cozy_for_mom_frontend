import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/service/user_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutModal extends StatefulWidget {
  const LogoutModal({super.key});

  @override
  State<LogoutModal> createState() => _LogoutModalState();
}

class _LogoutModalState extends State<LogoutModal> {
  var selected = false;
  late UserApiService userViewModel;
  late Map<String, dynamic> pregnantInfo;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserApiService>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;

    return FutureBuilder(
      future: userViewModel.getUserInfo(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pregnantInfo = snapshot.data!;
        }
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: primaryColor,
            color: Colors.white,
          ));
        }
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 0.0,
          child: Container(
            width: screenWidth - 2 * paddingValue,
            height: min(252.w, 452),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 15.w),
              child: Column(
                children: [
                  Text(
                    "로그아웃",
                    style: TextStyle(
                      color: mainTextColor,
                      fontSize: min(20.sp, 30),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${pregnantInfo['nickname']} ",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: min(14.sp, 24)),
                      ),
                      Text(
                        " 아이디가 로그아웃됩니다.",
                        style: TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: min(14.sp, 24)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Text(
                    "해당 아이디는 간편 아이디로 계속 유지되며,\n원하지 않을 경우 삭제 할 수 있습니다.",  // TODO 삭제 기능이 빠져서 문구 다시 수정해야할 듯
                    style: TextStyle(
                      color: offButtonTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: min(12.sp, 22),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.w,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await userViewModel.logOut(context);
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                    child: Container(
                      height: min(56.w, 96),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12.w)),
                      child: Text(
                        "확인",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: min(16.sp, 26),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
