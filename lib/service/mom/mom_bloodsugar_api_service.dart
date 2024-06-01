import 'dart:convert';
import 'dart:ffi';

import 'package:cozy_for_mom_frontend/model/bloodsugar_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BloodsugarApiService extends ChangeNotifier {
  Future<List<dynamic>> getBloodsugars(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/bloodsugar?date=$formattedDate');
      Response res = await get(url);
      // String jsonString =
      //     await rootBundle.loadString('assets/test_json/bloodsugar.json');

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> bloodsugarsData = body['data']['bloodSugars'];
        List<PregnantBloosdugar> bloodsugars =
            bloodsugarsData.map((bloodsugar) {
          return PregnantBloosdugar.fromJson(bloodsugar);
        }).toList();
        return bloodsugars;
      } else {
        throw Exception('HTTP 요청 실패: ${res.statusCode}');
      }
    } catch (e) {
      // 에러 처리
      print('error $e');
      throw e; // 예외 다시 던지기
    }
  }

  Future<Map<String, dynamic>> getPeriodBloodsugars(
      DateTime date, String type) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final url = Uri.parse(
          '$baseUrl/bloodsugar/period?date=$formattedDate&type=$type');
      Response res = await get(url);
      // String jsonString = await rootBundle
      //     .loadString('assets/test_json/bloodsugar_period.json');

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> bloodsugarsData = body['data']['bloodsugars'];
        List<BloodsugarPerPeriod> bloodsugars =
            bloodsugarsData.map((bloodsugar) {
          return BloodsugarPerPeriod.fromJson(bloodsugar);
        }).toList();
        String periodType = body['data']['type'];

        return {
          'type': periodType,
          'bloodsugars': bloodsugars,
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

  // TODO 혈당 수치 기록 api 연동
  Future<int> recordBloodsugar(
      DateTime dateTime, String type, int level) async {
    final url = Uri.parse('$baseUrl/bloodsugar');
    Map data = {
      'date': DateFormat('yyyy-MM-dd').format(dateTime),
      'type': type,
      'level': level
    };
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return responseData['data']['bloodSugarRecordId'];
    } else {
      throw Exception(
          '${DateFormat('yyyy-MM-dd HH:mm').format(dateTime)} $type 혈당 수치 기록을 실패하였습니다.');
    }
  }

  // TODO 혈당 수치 기록 수정 api 연동
  Future<int> modifyBloodsugar(
      int id, DateTime dateTime, String type, int level) async {
    final url = Uri.parse('$baseUrl/bloodsugar/$id');
    Map data = {
      'date': DateFormat('yyyy-MM-dd').format(dateTime),
      'type': type,
      'level': level
    };
    print(jsonEncode(data));
    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    print(response.statusCode);
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData['data']['bloodSugarRecordId'];
    } else {
      throw Exception(
          '${DateFormat('yyyy-MM-dd HH:mm').format(dateTime)} $type 혈당 수치 기록 수정을 실패하였습니다.');
    }
  }

  // TODO 영양제 섭취 기록 삭제 api 연동
  Future<void> deleteBloodsugar(int id) async {
    final url = Uri.parse('$baseUrl/bloodsugar/$id');
    Response res = await delete(url);
    if (res.statusCode == 204) {
      print('혈당 기록이 삭제되었습니다.');
    } else {
      throw '혈당 기록 삭제를 실패하였습니다.';
    }
  }
}
