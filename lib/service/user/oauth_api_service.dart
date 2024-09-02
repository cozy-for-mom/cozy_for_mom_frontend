import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/service/user/device_token_manager.dart'
    as DeviceTokenManager;
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';

enum OauthType { apple, kakao, none }

class OauthApiService {
  final tokenManager = TokenManager.TokenManager();
  final deviceTokenManager = DeviceTokenManager.DeviceTokenManager();
  Future<UserType?> authenticateByOauth(
    BuildContext context,
    OauthType oauthType,
    String value,
  ) async {
    var urlString = '$baseUrl/authenticate/oauth';
    final url = Uri.parse(urlString);
    String? deviceToken =
        await deviceTokenManager.getDeviceToken() ?? 'unknown';
    final headers = await getHeaders();
    dynamic res;
    print('dt $deviceToken');
    res = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'oauthType': oauthType.name,
          'deviceToken': deviceToken,
          'value': value,
        },
      ),
    );
    if (res.statusCode == 200) {
      final accessToken =
          (res.headers['authorization'] as String).split(' ')[1];
      tokenManager.setToken(accessToken);
      print('at $accessToken');
      final decoded = JwtDecoder.decode(accessToken);
      print('role ${UserType.findByString(decoded['info']['role'])}');

      return UserType.findByString(decoded['info']['role']);
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      return null;
      // throw Exception('코지로그 로그인 실패 (oauthType: $oauthType)');
    }
  }
}

enum UserType {
  guest,
  user;

  static UserType findByString(String type) {
    return UserType.values.firstWhere(
        (e) => e.name.toLowerCase() == type.toLowerCase(),
        orElse: () => throw Exception('No matching UserType for $type'));
  }
}
