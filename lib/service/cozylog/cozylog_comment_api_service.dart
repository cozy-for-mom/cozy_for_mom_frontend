import 'dart:convert';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:http/http.dart';

const baseUrl = "http://43.202.14.104:8080/api/v1"; // TODO remove
const headers = {'Content-Type': 'application/json; charset=UTF-8'};

class CozyLogCommentApiService {
  Future<List<CozyLogComment>> getCozyLogComments(
    int id,
  ) async {
    var urlString = '$baseUrl/cozy-log/$id/comment?userId=1';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body['data']['comments'];
      List<CozyLogComment> cozyLogs = data.map((comment) {
        return CozyLogComment.fromJson(comment);
      }).toList();
      return cozyLogs;
    } else {
      throw Exception('코지로그(id: $id) 댓글 조회 실패');
    }
  }

  Future<bool> postComment(
    int cozyLogId,
    int? parentId,
    String content,
  ) async {
    var urlString = '$baseUrl/cozy-log/$cozyLogId/comment?userId=1';
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
      throw Exception('코지로그(id: $cozyLogId) 댓글 작성 실패');
    }
  }
}
