import 'dart:convert';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CozyLogCommentApiService {
  Future<List<CozyLogComment>> getCozyLogComments(
    BuildContext context,
    int id,
  ) async {
    var urlString = '$baseUrl/cozy-log/$id/comment?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body['data']['comments'];
      List<CozyLogComment> cozyLogs = data.map((comment) {
        return CozyLogComment.fromJson(comment);
      }).toList();
      return cozyLogs;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $id) 댓글 조회 실패');
    }
  }

  Future<bool> postComment(
    BuildContext context,
    int cozyLogId,
    int? parentId,
    String content,
  ) async {
    var urlString = '$baseUrl/cozy-log/$cozyLogId/comment?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'parentId': parentId,
          'comment': content,
        },
      ),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $cozyLogId) 댓글 작성 실패');
    }
  }

  Future<bool> deleteComment(
    BuildContext context,
    int cozyLogId,
    int commentId,
  ) async {
    var urlString = '$baseUrl/cozy-log/$cozyLogId/comment/$commentId?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $cozyLogId) 댓글 삭제 실패');
    }
  }

  Future<bool> updateComment(
    BuildContext context,
    int cozyLogId,
    int commentId,
    int? parentId,
    String content,
  ) async {
    var urlString = '$baseUrl/cozy-log/$cozyLogId/comment?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await put(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'parentId': parentId,
          'commentId': commentId,
          'comment': content,
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $cozyLogId) 댓글 수정 실패');
    }
  }
}
