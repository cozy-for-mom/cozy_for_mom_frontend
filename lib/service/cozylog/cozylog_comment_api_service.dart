import 'dart:convert';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CozyLogCommentApiService with ChangeNotifier {
  Future<List<CozyLogComment>?> getCozyLogComments(
    BuildContext context,
    int id,
  ) async {
    var urlString = '$baseUrl/cozy-log/$id/comment?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await get(url, headers: headers);
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      List<dynamic> data = body['data']['comments'];
      print(data);
      List<CozyLogComment> cozyLogs = data.map((comment) {
        return CozyLogComment.fromJson(comment);
      }).toList();

      return cozyLogs;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception('코지로그(id: $id) 댓글 조회 실패');
    }
  }

  Future<bool?> postComment(
    BuildContext context,
    int cozyLogId,
    int? parentId,
    String content,
  ) async {
    var urlString = '$baseUrl/cozy-log/$cozyLogId/comment?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'parentId': parentId,
          'comment': content,
        },
      ),
    );
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
    if (res.statusCode == 201) {
      return true;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception('코지로그(id: $cozyLogId) 댓글 작성 실패');
    }
  }

  Future<bool?> deleteComment(
    BuildContext context,
    int cozyLogId,
    int commentId,
  ) async {
    var urlString = '$baseUrl/cozy-log/$cozyLogId/comment/$commentId?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await delete(
      url,
      headers: headers,
    );
    if (res.statusCode == 204) {
      return true;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, null);
      }
      return null;
      // throw Exception('코지로그(id: $cozyLogId) 댓글 삭제 실패');
    }
  }

  Future<bool?> updateComment(
    BuildContext context,
    int cozyLogId,
    int commentId,
    int? parentId,
    String content,
  ) async {
    var urlString = '$baseUrl/cozy-log/$cozyLogId/comment?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await put(
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
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
    if (res.statusCode == 200) {
      return true;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception('코지로그(id: $cozyLogId) 댓글 수정 실패');
    }
  }
}
