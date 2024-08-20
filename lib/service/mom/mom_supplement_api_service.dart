import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/supplement_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class SupplementApiService extends ChangeNotifier {
  Future<List<dynamic>?> getSupplements(
      BuildContext context, DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/supplement/intake?date=$formattedDate');
      final headers = await getHeaders();
      Response res = await get(url, headers: headers);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> supplementsData = body['data']['supplements'];
        List<PregnantSupplement> supplements =
            supplementsData.map((supplement) {
          return PregnantSupplement.fromJson(supplement);
        }).toList();
        return supplements;
      } else {
        if (context.mounted) {
          handleHttpResponse(res.statusCode, context);
        }
        return null;
        // throw Exception('$formattedDate 영양제 목록 조회를 실패하였습니다.');
      }
    } catch (e) {
      // 에러 처리
      print('$e');
      rethrow;
    }
  }

  Future<int?> recordSupplementIntake(
      BuildContext context, String name, DateTime takeTime) async {
    final url = Uri.parse('$baseUrl/supplement/intake');
    final headers = await getHeaders();
    Map data = {
      'supplementName': name,
      'datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(takeTime)
    };
    final Response res =
        await post(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> resData = jsonDecode(utf8.decode(res.bodyBytes));
    if (res.statusCode == 201) {
      return resData['data']['supplementRecordId'];
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      return null;
      // throw Exception('$name 섭취 기록 등록을 실패하였습니다.');
    }
  }

  Future<int?> modifySupplementIntake(
      BuildContext context, int id, String name, String takeTime) async {
    final url = Uri.parse('$baseUrl/supplement/intake/$id');
    final headers = await getHeaders();
    Map data = {'supplementName': name, 'datetime': takeTime};

    final Response res =
        await put(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> resData = jsonDecode(utf8.decode(res.bodyBytes));
    if (res.statusCode == 200) {
      return resData['data']['supplementRecordId'];
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      return null;
      // throw Exception('$name 섭취 기록 수정을 실패하였습니다.');
    }
  }

  Future<void> deleteSupplementIntake(BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/supplement/intake/$id');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);

    if (res.statusCode == 204) {
      print('$id 기록이 삭제되었습니다.');
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      // throw '$id 기록 삭제를 실패하였습니다.';
    }
  }

  Future<int?> registerSupplement(
      BuildContext context, String name, int targetCount) async {
    final url = Uri.parse('$baseUrl/supplement');
    final headers = await getHeaders();
    Map data = {'supplementName': name, 'targetCount': targetCount};
    final Response res =
        await post(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> resData = jsonDecode(utf8.decode(res.bodyBytes));
    if (res.statusCode == 201) {
      return resData['data']['supplementId'];
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      return null;
      // throw Exception('$name 영양제 등록을 실패하였습니다.');
    }
  }

  // TODO 나의 영양제 수정
  Future<PregnantSupplement?> modifySupplement(
      BuildContext context, String name, DateTime takeTime) async {
    final url = Uri.parse('$baseUrl/supplement/intake');
    final headers = await getHeaders();
    Map data = {'supplementName': name, 'datetime': takeTime.toIso8601String()};

    final Response res =
        await put(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode == 200) {
      return PregnantSupplement.fromJson(json.decode(res.body));
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      return null;
      // throw Exception('$name 섭취 기록 등록을 실패하였습니다.');
    }
  }

  Future<void> deleteSupplement(BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/supplement/$id');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);

    if (res.statusCode == 204) {
      print('$id 영양제가 삭제되었습니다.');
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      // throw '$id 영양제 삭제를 실패하였습니다.';
    }
  }
}
