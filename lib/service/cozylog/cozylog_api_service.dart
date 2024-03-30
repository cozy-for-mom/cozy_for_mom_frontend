import 'dart:convert';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:http/http.dart';

const baseUrl = "http://43.202.14.104:8080/api/v1"; // TODO remove
const headers = {'Content-Type': 'application/json; charset=UTF-8'};

class CozyLogApiService {
  Future<MyCozyLogListWrapper> getMyCozyLogs(
    int? lastId,
    int size,
  ) async {
    var urlString = '$baseUrl/me/cozy-log?size=$size';
    if (lastId != null) urlString += '&lastId=$lastId';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));

      int totalCount = body['data']['totalCount'];
      List<CozyLogForList> cozyLogs =
          (body['data']['cozyLogs'] as List<dynamic>).map((cozyLog) {
        return CozyLogForList.fromJson(cozyLog);
      }).toList();
      return MyCozyLogListWrapper(cozyLogs: cozyLogs, totalCount: totalCount);
    } else {
      throw Exception('코지로그 목록 조회 실패');
    }
  }

  Future<List<CozyLogForList>> getCozyLogs(
    int? lastId,
    int size,
  ) async {
    var urlString = '$baseUrl/cozy-log/list?size=$size';
    if (lastId == null) urlString += '&lastId=0';
    urlString += '&sort=LATELY';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body['data']['cozyLogs'];
      List<CozyLogForList> cozyLogs = data.map((cozyLog) {
        return CozyLogForList.fromJson(cozyLog);
      }).toList();
      return cozyLogs;
    } else {
      throw Exception('코지로그 목록 조회 실패');
    }
  }

  Future<CozyLog> getCozyLog(
    int id,
  ) async {
    var urlString = '$baseUrl/cozy-log/$id?userId=1';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      dynamic data = body['data'];
      return CozyLog.fromJson(data);
    } else {
      throw Exception('코지로그(id: $id) 조회 실패');
    }
  }

  Future<int> updateCozyLog(
    int id,
    String title,
    String content,
    CozyLogModeType mode,
  ) async {
    var urlString = '$baseUrl/cozy-log?userId=1';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await put(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'id': id,
          'title': title,
          'content': content,
          'mode': switch (mode) {
            CozyLogModeType.private => 'PRIVATE',
            CozyLogModeType.public => 'PUBLIC',
          },
          'imageList': [],
        },
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> data = body['data'];
      return data['modifiedCozyLogId'] as int;
    } else {
      throw Exception('코지로그(id: $id) 수정 실패');
    }
  }

  void deleteCozyLog(
    int id,
  ) async {
    var urlString = '$baseUrl/cozy-log/$id?userId=1';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception('코지로그(id: $id) 삭제 실패');
    }
  }

  Future<void> scrapCozyLog(
    int cozyLogId,
  ) async {
    var urlString = '$baseUrl/scrap';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'cozyLogId': cozyLogId,
          'isScraped': true,
        },
      ),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('코지로그(id: $cozyLogId) 스크랩 실패');
    }
  }

  Future<void> unscrapCozyLog(
    int cozyLogId,
  ) async {
    var urlString = '$baseUrl/scrap';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'cozyLogId': cozyLogId,
          'isScraped': false,
        },
      ),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('코지로그(id: $cozyLogId) 스크랩 실패');
    }
  }
}
