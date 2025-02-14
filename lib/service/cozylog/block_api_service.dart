import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BlockApiService extends ChangeNotifier {
  Future<void> violateCozyLog(
      BuildContext context, int cozylogId, String reason) async {
    final url = Uri.parse('$baseUrl/cozy-log/violation/log');
    final headers = await getHeaders();
    Map data = {'cozylogId': cozylogId, 'reason': reason};
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
