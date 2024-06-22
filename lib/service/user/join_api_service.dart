import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/model/user_join_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JoinApiService extends ChangeNotifier {
  Future<Map<String, dynamic>> signUp(
      UserInfo userInfo, BabyInfo babyInfo) async {
    final url = Uri.parse('$baseUrl/user/signup');
    final headers = await getHeaders();
    Map data = {
      'userInfo': userInfo.toJson(),
      'babyInfo': babyInfo.toJson(),
    };
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('회원가입을 실패하였습니다.');
    }
  }

  Future<bool> nicknameDuplicateCheck(String nickname) async {
    final url = Uri.parse('$baseUrl/authenticate/nickname');
    final data = {'nickname': nickname};
    final headers = await getHeaders();
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 409) {
      return false;
    } else {
      throw Exception('닉네임 중복 확인 실패');
    }
  }
}
