import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;

class IdempotencyKeyManager {
  // 해싱(멱등키 생성) 함수
  String generateIdempotencyKey(
      String url, int userId, Map<dynamic, dynamic>? body) {
    // 1) 합칠 문자열 생성 > body가 null이면, url + userId로만 생성
    final rawString =
        (body == null) ? '$url$userId' : '$url$userId${jsonEncode(body)}';

    // 2) 문자열을 UTF-8 바이트로 변환
    final bytes = utf8.encode(rawString);

    // 3) SHA-256 해시 계산
    final digest = sha256.convert(bytes);

    // 4) 해시 결과(바이너리)를 Hex 문자열로 변환 (digest.toString()은 기본적으로 hex로 변환된 문자열)
    return digest.toString();
  }

// 토큰으로부터 사용자 id 추출하는 함수
  Future<int> extractUserId() async {
    final tokenManager = TokenManager.TokenManager();
    String? token = await tokenManager.getToken();

    final decoded = JwtDecoder.decode(token!);
    final userId = decoded['info']['userId'];

    return int.parse(userId);
  }
}
