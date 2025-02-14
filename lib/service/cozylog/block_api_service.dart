import 'dart:convert';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:crypto/crypto.dart';

import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// 해싱(멱등키 생성) 함수
String _generateIdempotencyKey(
    String url, int userId, Map<dynamic, dynamic> body) {
  // 1) 합칠 문자열 생성
  final rawString = '$url$userId${jsonEncode(body)}';
  
  // 2) 문자열을 UTF-8 바이트로 변환
  final bytes = utf8.encode(rawString);

  // 3) SHA-256 해시 계산
  final digest = sha256.convert(bytes);

  // 4) 해시 결과(바이너리)를 Hex 문자열로 변환 (digest.toString()은 기본적으로 hex로 변환된 문자열)
  return digest.toString();
}

// 토큰으로부터 사용자 id 추출하는 함수
Future<int> _extractUserId() async {
  final tokenManager = TokenManager.TokenManager();
  String? token = await tokenManager.getToken();

  final decoded = JwtDecoder.decode(token!);
  final userId = decoded['info']['userId'];

  return int.parse(userId);
}

class BlockApiService extends ChangeNotifier {
  Future<void> violateCozyLog(
      BuildContext context, int cozylogId, String reason) async {
    final url = Uri.parse('$baseUrl/cozy-log/violation/log');
    final headers = await getHeaders();
    Map data = {'cozylogId': cozylogId, 'reason': reason};

    // 사용자 id
    final userId = await _extractUserId();

    // 멱등키 생성 (SHA-256)
    final idempotencyKey =
        _generateIdempotencyKey(url.toString(), userId, data);

    // 헤더에 추가
    headers['X-Idempotency-Key'] = idempotencyKey;

    final Response res =
        await post(url, headers: headers, body: jsonEncode(data));
    String? message;

    // 응답 본문이 비어있지 않을 경우만 JSON 파싱
    if (res.body.isNotEmpty) {
      try {
        final Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(res.bodyBytes));

        if (responseBody.containsKey('message')) {
          message = responseBody['message'];
        }
      } catch (e) {
        print("JSON 파싱 오류: $e");
      }
    }
    // 상태 코드가 201이 아닐 때만 에러 처리
    if (res.statusCode != 201 && context.mounted) {
      handleHttpResponse(res.statusCode, context, message);
    }
  }

  Future<void> violateComment(
      BuildContext context, int commentId, String reason) async {
    final url = Uri.parse('$baseUrl/cozy-log/violation/comment');
    final headers = await getHeaders();
    Map data = {'commentId': commentId, 'reason': reason};

    final userId = await _extractUserId();

    final idempotencyKey =
        _generateIdempotencyKey(url.toString(), userId, data);
    headers['X-Idempotency-Key'] = idempotencyKey;

    final Response res =
        await post(url, headers: headers, body: jsonEncode(data));
    String? message;

    if (res.body.isNotEmpty) {
      try {
        final Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(res.bodyBytes));

        if (responseBody.containsKey('message')) {
          message = responseBody['message'];
        }
      } catch (e) {
        print("JSON 파싱 오류: $e");
      }
    }
    if (res.statusCode != 201 && context.mounted) {
      handleHttpResponse(res.statusCode, context, message);
    }
  }

  Future<void> blockUser(BuildContext context, int targetId) async {
    final url = Uri.parse('$baseUrl/user/block');
    final headers = await getHeaders();
    Map data = {'targetId': targetId};

    final userId = await _extractUserId();

    final idempotencyKey =
        _generateIdempotencyKey(url.toString(), userId, data);
    headers['X-Idempotency-Key'] = idempotencyKey;

    final Response res =
        await post(url, headers: headers, body: jsonEncode(data));
    // String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];  // TODO 에러나면 어떻게 넘겨줘?

    if (res.statusCode != 201) {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, null);
      }
    }
  }
}
