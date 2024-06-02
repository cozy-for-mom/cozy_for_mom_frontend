import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JoinApiService extends ChangeNotifier {
  Future<void> signUp(UserInfo userInfo, BabyInfo babyInfo) async {
    final url = Uri.parse('$baseUrl/user/signup');
    Map data = {
      'userInfo': userInfo.toJson(),
      'babyInfo': babyInfo.toJson(),
    };
    print(data);
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    print(utf8.decode(response.bodyBytes));
    print(response.statusCode);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('회원가입을 실패하였습니다.');
    }
  }
}
