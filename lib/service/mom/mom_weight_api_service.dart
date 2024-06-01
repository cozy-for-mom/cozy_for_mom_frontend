import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/weight_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WeightApiService extends ChangeNotifier {
  Future<Map<String, dynamic>> getWeights(DateTime date, String type) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/weight?date=$formattedDate&type=$type');
      Response res = await get(url);
      // String jsonString =
      //     await rootBundle.loadString('assets/test_json/weight.json');
      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> weightsData = body['data']['weightList'];
        List<PregnantWeight> weights = weightsData.map((weight) {
          return PregnantWeight.fromJson(weight);
        }).toList();
        double todayWeight = body['data']['todayWeight'];
        String lastRecordDate = body['data']['lastRecordDate'];

        return {
          'todayWeight': todayWeight,
          'weights': weights,
          'lastRecordDate': lastRecordDate
        };
      } else {
        throw Exception('HTTP 요청 실패: ${res.statusCode}');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  Future<void> recordWeight(DateTime dateTime, double weight) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final url = Uri.parse('$baseUrl/weight');
    Map data = {'date': formattedDate, 'weight': weight};
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(
          '${DateFormat('yyyy-MM-dd HH:mm').format(dateTime)} 체중 기록을 실패하였습니다.');
    }
  }

  Future<void> modifyWeight(DateTime dateTime, double weight) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final url = Uri.parse('$baseUrl/weight?date=$formattedDate');
    Map data = {'weight': weight};

    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(
          '${DateFormat('yyyy-MM-dd HH:mm').format(dateTime)} 체중 기록 수정을 실패하였습니다.');
    }
  }
}
