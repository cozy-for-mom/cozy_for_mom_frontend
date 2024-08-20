import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/weight_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WeightApiService extends ChangeNotifier {
  Future<Map<String, dynamic>> getWeights(
      BuildContext context, DateTime date, String type) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/weight?date=$formattedDate&type=$type');
      final headers = await getHeaders();
      Response res = await get(url, headers: headers);
      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> weightsData = body['data']['weightList'];
        List<PregnantWeight> weights = weightsData.map((weight) {
          return PregnantWeight.fromJson(weight);
        }).toList();
        double todayWeight = body['data']['todayWeight'];
        String lastRecordDate = body['data']['lastRecordDate'] ?? '';

        return {
          'todayWeight': todayWeight,
          'weightList': weights,
          'lastRecordDate': lastRecordDate
        };
      } else {
        if (context.mounted) {
          handleHttpResponse(res.statusCode, context);
        }
        return {};
        // throw Exception('$formattedDate $type 체중 조회를 실패하였습니다.');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  Future<void> recordWeight(
      BuildContext context, DateTime dateTime, double weight) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final url = Uri.parse('$baseUrl/weight');
    final headers = await getHeaders();
    Map data = {'date': formattedDate, 'weight': weight};
    final Response res =
        await post(url, headers: headers, body: jsonEncode(data));

    if (res.statusCode == 200) {
      notifyListeners();
      return;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      // throw Exception(
      // '${DateFormat('yyyy-MM-dd HH:mm').format(dateTime)} 체중 기록을 실패하였습니다.');
    }
  }

  Future<void> modifyWeight(
      BuildContext context, DateTime dateTime, double weight) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final url = Uri.parse('$baseUrl/weight?date=$formattedDate');
    final headers = await getHeaders();
    Map data = {'weight': weight};

    final Response res =
        await put(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode == 200) {
      notifyListeners();
      return;
    } else {
      if (context.mounted) {
        handleHttpResponse(res.statusCode, context);
      }
      // throw Exception(
      //     '${DateFormat('yyyy-MM-dd HH:mm').format(dateTime)} 체중 기록 수정을 실패하였습니다.');
    }
  }
}
