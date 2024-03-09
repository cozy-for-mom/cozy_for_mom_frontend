import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/weight_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WeightApiService extends ChangeNotifier {
  Future<Map<String, dynamic>> getWeights(DateTime date, String type) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/weight?date=$formattedDate&type=$type');
      // TODO api 실제 테스트 시 위의 코드 주석 처리 및 아래 코드 주석 해제
      Response res = await get(url);
      String jsonString =
          await rootBundle.loadString('assets/test_json/weight.json');

      // TODO 상태 코드에 따른 에러 처리 추가
      // if (jsonString.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      List<dynamic> weightsData = body['data']['weightList'];
      List<PregnantWeight> weights = weightsData.map((weight) {
        return PregnantWeight.fromJson(weight);
      }).toList();
      double todayWeight = body['data']['todayWeight'];

      return {
        'todayWeight': todayWeight,
        'weights': weights,
      };
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  // TODO 체중 기록 api 연동
  Future<PregnantWeight> recordWeights(DateTime dateTime, double weight) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final url = Uri.parse('$baseUrl/weight');
    Map data = {'date': formattedDate, 'weight': weight};

    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return PregnantWeight.fromJson(json.decode(response.body));
    } else {
      throw Exception('$dateTime 체중 기록 등록을 실패하였습니다.');
    }
  }

  Future<PregnantWeight> modifyWeights(DateTime dateTime, double weight) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final url = Uri.parse('$baseUrl/weight?date=$formattedDate');
    Map data = {'weight': weight};

    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return PregnantWeight.fromJson(json.decode(response.body));
    } else {
      throw Exception('$dateTime 체중 기록 수정을 실패하였습니다.');
    }
  }

  // TODO 영양제 섭취 기록 삭제 api 연동
  Future<void> deleteWeight(DateTime dateTime) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final url = Uri.parse('$baseUrl/weight?date=$formattedDate');
    Response res = await delete(url);

    if (res.statusCode == 200) {
      print('$dateTime 체중 기록이 삭제되었습니다.');
    } else {
      throw '$dateTime 체중 기록 삭제를 실패하였습니다.';
    }
  }
}
