import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';

enum OauthType { apple, kakao, none }

class OauthApiService {
  final tokenManager = TokenManager.TokenManager();
  Future<UserType> authenticateByOauth(
    OauthType oauthType,
    String value,
  ) async {
    // TODO 일단 device token은 일단 빈값을 담아 요청한다.
    var urlString = '$baseUrl/authenticate/oauth';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'oauthType': oauthType.name,
          'deviceToken': '',
          'value': value,
        },
      ),
    );

    if (response.statusCode == 200) {
      final accessToken =
          (response.headers['authorization'] as String).split(' ')[1];
      tokenManager.setToken(accessToken);
      final decoded = JwtDecoder.decode(accessToken);
      return UserType.findByString(decoded['info']['role']);
    } else {
      throw Exception('코지로그 로그인 실패 (oauthType: $oauthType)');
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
