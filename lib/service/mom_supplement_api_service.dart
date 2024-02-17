import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/supplement_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SupplementApiService extends ChangeNotifier {
  Future<List<dynamic>> getSupplements(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/supplement/intake?date=$formattedDate');
      // Response res = await get(url);
      String jsonString =
          await rootBundle.loadString('assets/test_json/supplement.json');

      // if (jsonString.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(jsonString);
      List<dynamic> supplementsData = body['data']['supplements'];
      List<PregnantSupplement> supplements = supplementsData.map((supplement) {
        return PregnantSupplement.fromJson(supplement);
      }).toList();
      return supplements;
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  Future<PregnantSupplement> registerSupplement(
      PregnantSupplement supplement) async {
    final url = Uri.parse('$baseUrl/supplement');
    Map data = {
      'supplementName': supplement.supplementName,
      'targetCount': supplement.targetCount
    };
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return PregnantSupplement.fromJson(json.decode(response.body));
    } else {
      throw Exception('${supplement.supplementName} 등록을 실패하였습니다.');
    }
  }

  Future<PregnantSupplement> recordSupplementIntake(
      String name, DateTime takeTime) async {
    final url = Uri.parse('$baseUrl/supplement/intake');
    Map data = {'supplementName': name, 'dateTime': takeTime.toIso8601String()};

    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return PregnantSupplement.fromJson(json.decode(response.body));
    } else {
      throw Exception('$name 섭취 기록 등록을 실패하였습니다.');
    }
  }

  Future<void> deleteSupplement(String name, DateTime takeTime) async {
    final url = Uri.parse('$baseUrl/supplement/intake');
    Response res = await delete(url);

    if (res.statusCode == 200) {
      print('${name}-${takeTime} 기록이 삭제되었습니다.');
    } else {
      throw '${name}-${takeTime} 기록 삭제를 실패하였습니다.';
    }
  }
}
