import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/service/user/user_local_storage_service.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BabyGrowthApiService {
  Future<int?> registerBabyProfileGrowth(
      BuildContext context, BabyProfileGrowth growth) async {
    final headers = await getHeaders();
    String? message;

    if (growth.id != null) {
      final url = Uri.parse("$baseUrl/growth/${growth.id}");
      final res = await put(
        url,
        headers: headers,
        body: jsonEncode(growth.toJson()),
      );
      message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body)['data']['growthReportId'];
      } else {
        throw Exception('성장 보고서 저장 실패');
      }
    } else {
      final url = Uri.parse("$baseUrl/growth");
      final res = await post(
        url,
        headers: headers,
        body: jsonEncode(growth.toJson()),
      );
      message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body)['data']['growthReportId'];
      } else {
        if (context.mounted) {
          if (context.mounted) {
            handleHttpResponse(res.statusCode, context, message);
          }
        }
        return null;
        // throw Exception('성장 보고서 저장 실패');
      }
    }
  }

  Future<BabyProfileGrowthResult?> getBabyProfileGrowths(
    BuildContext context,
    int? lastId,
    int size,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    var urlString = '$baseUrl/growth/$babyProfileId/board?size=$size';
    final headers = await getHeaders();
    if (lastId != null && lastId != 0) urlString += '&lastId=$lastId';
    // if (lastId != null) urlString += '&lastId=null';
    final url = Uri.parse(urlString);
    print(url);
    dynamic res;
    res = await get(url, headers: headers);
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      List<dynamic> data = body['data']['list'];
      DateTime? nextExaminationDate = body['data']['nextExaminationDate'] == ""
          ? null
          : DateTime.parse(body['data']['nextExaminationDate']);
      int lastId = body['data']['lastId'];
      int? totalCount = body['data']['totalCount'] ?? 0;

      List<BabyProfileGrowth> growths = data.map((growth) {
        return BabyProfileGrowth.fromJson(growth, babyProfileId!);
      }).toList();
      return BabyProfileGrowthResult(
          growths: growths,
          nextExaminationDate: nextExaminationDate,
          lastId: lastId,
          totalCount: totalCount);
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception('성장 보고서 목록 조회 실패');
    }
  }

  Future<List<int>> getAllGrowthIds(
    BuildContext context,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    var urlString = '$baseUrl/growth/all/$babyProfileId';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await get(url, headers: headers);
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      List<int> ids = List<int>.from(
          body['data']['ids'].map((id) => int.parse(id.toString())));
      return ids;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return [];
      // throw Exception('모든 성장보고서 id 목록 조회 실패');
    }
  }

  Future<BabyProfileGrowth?> getBabyProfileGrowth(
    BuildContext context,
    int id,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    var urlString = '$baseUrl/growth/$id';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await get(url, headers: headers);
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      dynamic data = body['data'];
      BabyProfileGrowth growth =
          BabyProfileGrowth.fromJson(data, babyProfileId!);
      return growth;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      return null;
      // throw Exception('성장 보고서 조회 실패 - id: $id');
    }
  }

  Future<void> registerNotificationExaminationDate(
    BuildContext context,
    String examinationAt,
    List<String> notificationOptions,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    var urlString = '$baseUrl/notification/examination';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await post(url,
        headers: headers,
        body: jsonEncode({
          'babyProfileId': babyProfileId,
          'examinationAt': examinationAt,
          'notifyAt': notificationOptions,
        }));
    String? message = jsonDecode(utf8.decode(res.bodyBytes))['message'];

    if (res.statusCode == 201) {
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, message);
      }
      // throw Exception('다음검진일 설정 실패');
    }
  }

  Future<void> bulkDeleteBabyProfileGrowth(
    BuildContext context,
    List<int> growthIds,
  ) async {
    var urlString = '$baseUrl/growth/bulk';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic res;
    res = await delete(
      url,
      headers: headers,
      body: jsonEncode(
        {
          'growthIds': growthIds,
        },
      ),
    );

    if (res.statusCode == 204) {
      print("성장보고서 삭제왼료");
      return;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, null);
      }
      // throw Exception('성장보고서(ids: $growthIds) 삭제 실패');
    }
  }

  Future<void> allDeleteBabyProfileGrowth(
      BuildContext context, int babyProfileId) async {
    final url = Uri.parse('$baseUrl/growth/all/$babyProfileId');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);

    if (res.statusCode == 204) {
      print('$babyProfileId 성장보고서 기록이 삭제되었습니다.');
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, null);
      }
      // throw '모든 성장보고서 기록 삭제를 실패하였습니다.';
    }
  }

  Future<void> deleteBabyProfileGrowth(BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/growth/$id');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);

    if (res.statusCode == 204) {
      print('$id 성장보고서 기록이 삭제되었습니다.');
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context, null);
      }
      // throw '$id 성장보고서 기록 삭제를 실패하였습니다.';
    }
  }
}
