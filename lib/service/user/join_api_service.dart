import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JoinApiService extends ChangeNotifier {
  final tokenManager = TokenManager.TokenManager();
  Future<void> signUp(UserInfo userInfo, BabyInfo babyInfo) async {
    final url = Uri.parse('$baseUrl/user/signup');
    String? token = await tokenManager.getToken(); // 비동기적으로 토큰을 받아옴
    Map data = {
      'userInfo': userInfo.toJson(),
      'babyInfo': babyInfo.toJson(),
    };
    print(data);
    final updatedHeaders = {
      ...headers, // 기존 헤더 확장
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final Response response =
        await post(url, headers: updatedHeaders, body: jsonEncode(data));
    print(utf8.decode(response.bodyBytes));
    print(response.statusCode);

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('회원가입을 실패하였습니다.');
    }
  }
}
