import 'dart:convert';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CozyLogApiService {
  Future<MyCozyLogListWrapper> getMyCozyLogs(
    BuildContext context,
    int? lastId,
    int size,
  ) async {
    var urlString = '$baseUrl/me/cozy-log?size=$size';
    final headers = await getHeaders();
    if (lastId != null) urlString += '&lastId=$lastId';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));

      int totalCount = body['data']['totalCount'];
      List<CozyLogForList> cozyLogs =
          (body['data']['cozyLogs'] as List<dynamic>).map((cozyLog) {
        return CozyLogForList.fromJson(cozyLog);
      }).toList();
      return MyCozyLogListWrapper(cozyLogs: cozyLogs, totalCount: totalCount);
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그 목록 조회 실패');
    }
  }

  Future<ScrapCozyLogListWrapper> getScrapCozyLogs(
    BuildContext context,
    int? lastId,
    int size,
  ) async {
    var urlString = '$baseUrl/scrap?userId=1&size=$size';
    final headers = await getHeaders();
    if (lastId != null) {
      urlString += '&lastId=$lastId';
    }
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      int totalCount = body['data']['totalCount'];
      List<CozyLogForList> cozyLogs =
          (body['data']['cozyLogs'] as List<dynamic>).map((cozyLog) {
        return CozyLogForList.fromJson(cozyLog);
      }).toList();
      return ScrapCozyLogListWrapper(
          cozyLogs: cozyLogs, totalCount: totalCount);
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그 목록 조회 실패');
    }
  }

  Future<List<CozyLogForList>> getCozyLogs(
    BuildContext context,
    int? lastId,
    int size, {
    String sortType = 'LATELY',
  }) async {
    var urlString = '$baseUrl/cozy-log/list?size=$size';
    final headers = await getHeaders();
    if (lastId == null) {
      urlString += '&lastId=0';
    } else {
      urlString += '&lastId=$lastId';
    }
    urlString += '&sort=$sortType';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body['data']['cozyLogs'];
      List<CozyLogForList> cozyLogs = data.map((cozyLog) {
        return CozyLogForList.fromJson(cozyLog);
      }).toList();
      return cozyLogs;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그 목록 조회 실패');
    }
  }

  Future<CozyLogSearchResponse> searchCozyLogs(
    BuildContext context,
    String keyword,
    int? lastId,
    int size,
    CozyLogSearchSortType sortType,
  ) async {
    var urlString = '$baseUrl/cozy-log/search?size=$size';
    final headers = await getHeaders();

    if (lastId == null) {
      urlString += '&lastId=0';
    } else {
      urlString += '&lastId=$lastId';
    }

    urlString += '&keyword=$keyword';

    var sortTypeString = 'LATELY';
    if (sortType == CozyLogSearchSortType.comment) {
      sortTypeString = 'COMMENT';
    }
    urlString += '&sort=$sortTypeString';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<CozyLogSearchResult> cozyLogs =
          (body['data']['results'] as List<dynamic>).map((cozyLog) {
        return CozyLogSearchResult.fromJson(cozyLog);
      }).toList();
      int totalCount = body['data']['totalCount'];
      return CozyLogSearchResponse(
        results: cozyLogs,
        totalElements: totalCount,
      );
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그 검색 조회 실패');
    }
  }

  Future<CozyLog> getCozyLog(
    BuildContext context,
    int id,
  ) async {
    var urlString = '$baseUrl/cozy-log/$id?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      dynamic data = body['data'];
      return CozyLog.fromJson(data);
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $id) 조회 실패');
    }
  }

  Future<int> createCozyLog(
    BuildContext context,
    String title,
    String content,
    List<CozyLogImage> images,
    CozyLogModeType mode,
  ) async {
    var urlString = '$baseUrl/cozy-log';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'title': title,
          'content': content,
          'mode': switch (mode) {
            CozyLogModeType.private => 'PRIVATE',
            CozyLogModeType.public => 'PUBLIC',
          },
          'imageList': images
              .map((e) => {
                    "imageId": e.imageId,
                    "imageUrl": e.imageUrl,
                    "description": e.description,
                  })
              .toList(),
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> data = body['data'];
      return data['cozyLogId'] as int;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그 작성 실패');
    }
  }

  Future<int> updateCozyLog(
    BuildContext context,
    int id,
    String title,
    String content,
    List<CozyLogImage> images,
    CozyLogModeType mode,
  ) async {
    var urlString = '$baseUrl/cozy-log?userId=1';
    final headers = await getHeaders();
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
          'imageList': images
              .map((e) => {
                    "imageId": e.imageId,
                    "imageUrl": e.imageUrl,
                    "description": e.description,
                  })
              .toList(),
        },
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> data = body['data'];
      return data['modifiedCozyLogId'] as int;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $id) 수정 실패');
    }
  }

  void deleteCozyLog(
    BuildContext context,
    int id,
  ) async {
    var urlString = '$baseUrl/cozy-log/$id?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 204) {
      return;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $id) 삭제 실패');
    }
  }

  Future<void> scrapCozyLog(
    BuildContext context,
    int cozyLogId,
  ) async {
    var urlString = '$baseUrl/scrap';
    final headers = await getHeaders();
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
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $cozyLogId) 스크랩 실패');
    }
  }

  Future<void> unscrapCozyLog(
    BuildContext context,
    int cozyLogId,
  ) async {
    var urlString = '$baseUrl/scrap';
    final headers = await getHeaders();
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
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(id: $cozyLogId) 스크랩 실패');
    }
  }

  Future<void> bulkDeleteCozyLog(
    BuildContext context,
    List<int> cozyLogIds,
  ) async {
    var urlString = '$baseUrl/me/cozy-log';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await delete(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'cozyLogIds': cozyLogIds,
        },
      ),
    );
    if (response.statusCode == 204) {
      print("삭제왼료");
      return;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(ids: $cozyLogIds) 삭제 실패');
    }
  }

  Future<void> bulkAllDeleteCozyLog(
    BuildContext context,
    List<int> cozyLogIds,
  ) async {
    var urlString = '$baseUrl/me/cozy-log/all';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'cozyLogIds': cozyLogIds,
        },
      ),
    );

    if (response.statusCode == 204) {
      return;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(ids: $cozyLogIds) 삭제 실패');
    }
  }

  Future<void> bulkUnscrapCozyLog(
    BuildContext context,
    List<int> cozyLogIds,
  ) async {
    var urlString = '$baseUrl/scrap/unscraps?userId=1';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'cozyLogIds': cozyLogIds,
        },
      ),
    );

    if (response.statusCode == 204) {
      return;
    } else {
      handleHttpResponse(response.statusCode, context);
      throw Exception('코지로그(ids: $cozyLogIds) unscrap 실패');
    }
  }
}
