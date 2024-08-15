import 'dart:convert';

import 'package:cozy_for_mom_frontend/screen/join/join_input_data.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/model/user_join_model.dart';
import 'package:cozy_for_mom_frontend/service/user/oauth_api_service.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JoinApiService extends ChangeNotifier {
  final tokenManager = TokenManager.TokenManager();

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
    print(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      final accessToken =
          (response.headers['authorization'] as String).split(' ')[1];
      tokenManager.setToken(accessToken);
      final decoded = JwtDecoder.decode(accessToken);
      print(UserType.findByString(decoded['info']['role']));
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('회원가입을 실패하였습니다.');
    }
  }

  Future<bool> nicknameDuplicateCheck(String nickname) async {
    final url = Uri.parse('$baseUrl/authenticate/nickname');
    final data = {'nickname': nickname};
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
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

  Future<bool> emailDuplicateCheck(String email) async {
    final url = Uri.parse('$baseUrl/authenticate/email');
    final data = {'email': email};
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    print('요청 바디: ${jsonEncode(data)}');
    print(headers);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 409) {
      return false;
    } else {
      throw Exception('이메일 중복 확인 실패');
    }
  }

  Future<void> signOut(String reason) async {
    final url = Uri.parse('$baseUrl/user/signout');
    final data = {'reason': reason};
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode == 204) {
      await tokenManager.deleteToken();
      JoinInputData().resetData();
      print('회원탈퇴가 완료되었습니다.');
    } else {
      throw '회원탈퇴를 실패하였습니다.';
    }
  }
}
