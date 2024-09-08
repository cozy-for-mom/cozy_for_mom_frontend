import 'dart:async';

import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:flutter/material.dart';

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
          await showAlertDialog(context, '인증되지 않은 사용자입니다.');
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }
      }
      break;
    case 500:
      // 서버 내부 오류
      showAlertDialog(context, '알 수 없는 오류가 발생했습니다.');
      break;
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
        child: Container(
          width: screenWidth * (1 / 3),
          height: AppUtils.scaleSize(context, 41),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            '$message',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: AppUtils.scaleSize(context, 16)),
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
