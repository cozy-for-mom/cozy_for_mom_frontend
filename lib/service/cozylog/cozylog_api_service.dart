import 'dart:convert';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:http/http.dart';

const baseUrl = "http://43.202.14.104:8080/api/v1"; // TODO remove

class CozyLogApiService {
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
      throw Exception('성장 보고서 목록 조회 실패');
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
      throw Exception('성장 보고서(id: $id) 조회 실패');
    }
  }
}
