import 'dart:async';
import 'dart:math';

import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void handleHttpResponse(
    int statusCode, BuildContext context, String? message) async {
  final tokenManager = TokenManager.TokenManager();
  ModalRoute? route = ModalRoute.of(context);
  switch (statusCode) {
    case 200:
      // 성공 로직
      break;
    case 400:
      showAlertDialog(context, message ?? '잘못된 형식의 입력값입니다.');
      break;
    case 401:
    // 인증 실패
    case 403:
      // 접근 금지
      await tokenManager.deleteToken();
      // 다이얼로그를 먼저 보여준 후 사용자 확인 후 로그인 페이지로 이동
      if (context.mounted) {
        var currentRoute = ModalRoute.of(context)?.settings.name;
        if (route != null && currentRoute != '/login') {
          await showAlertDialog(context, message ?? '인증되지 않은 사용자입니다.');
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }
      }
      break;
    case 404:
      // 요청한 리소스 부재
      showAlertDialog(context, message ?? '존재하지 않는 리소스입니다.');
    case 409:
      // 입력값 중복
      showAlertDialog(context, message ?? '이미 존재하는 데이터입니다.');
    case 500:
      // 서버 내부 오류
    default:
      // 기타 오류
      showAlertDialog(context, message ?? '알 수 없는 오류가 발생했습니다.');
  }
}

Future<void> showAlertDialog(BuildContext context, String? message) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;

      // Timer(const Duration(seconds: 5), () {
      //   if (Navigator.of(context).canPop()) {
      //     // 안전하게 닫을 수 있는지 확인
      //     Navigator.of(context).pop();
      //   }
      // });

      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Container(
          width: screenWidth * (0.45),
          // padding: EdgeInsets.symmetric(horizontal: 10.w),
          height: 41.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              borderRadius: BorderRadius.circular(10.w)),
          child: Text(
            '$message',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: min(16.sp, 26),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );
  // .then((_) {
  //   // 다이얼로그가 닫힌 후 필요한 추가 작업을 여기에 넣을 수 있다.
  // });
}
