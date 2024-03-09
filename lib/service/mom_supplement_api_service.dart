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
      // TODO api 실제 테스트 시 위의 코드 주석 처리 및 아래 코드 주석 해제
      Response res = await get(url);
      print(res.body);
      String jsonString =
          await rootBundle.loadString('assets/test_json/supplement.json');

      // TODO 상태 코드에 따른 에러 처리 추가
      // if (jsonString.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
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

  // TODO 섭취 영양제 기록 api 연동
  Future<PregnantSupplement> recordSupplementIntake(
      String name, DateTime takeTime) async {
    final url = Uri.parse('$baseUrl/supplement/intake');
    Map data = {
      'supplementName': name,
      'dateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(takeTime)
    };

    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      print(json.decode(response.body)['data']['id']);
      return json.decode(response.body)['data']['id'];
    } else {
      throw Exception('$name 섭취 기록 등록을 실패하였습니다.');
    }
  }

  // TODO 섭취 영양제 기록 수정api 연동
  Future<PregnantSupplement> modifySupplementIntake(
      String name, DateTime takeTime, int id) async {
    final url = Uri.parse('$baseUrl/supplement/intake/$id');
    Map data = {
      'supplementName': name,
      'dateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(takeTime)
    };

    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['id'];
      //PregnantSupplement.fromJson(json.decode(response.body));
    } else {
      throw Exception('$name 섭취 기록 등록 수정을 실패하였습니다.');
    }
  }

  // TODO 영양제 섭취 기록 삭제 api 연동
  Future<void> deleteSupplementIntake(int id) async {
    final url = Uri.parse('$baseUrl/supplement/intake/$id');
    Response res = await delete(url);

    if (res.statusCode == 200) {
      print('기록이 삭제되었습니다.');
    } else {
      throw '기록 삭제를 실패하였습니다.';
    }
  }

  // TODO 나의 영양제 등록 api 연동
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
      return json.decode(response.body)['data']['supplementId'];
    } else {
      throw Exception('${supplement.supplementName} 등록을 실패하였습니다.');
    }
  }

  // TODO 나의 영양제 수정 api 연동
  Future<PregnantSupplement> modifySupplement(
      PregnantSupplement supplement, int id) async {
    final url = Uri.parse('$baseUrl/supplement/$id');
    Map data = {
      'supplementName': supplement.supplementName,
      'targetCount': supplement.targetCount
    };
    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['supplementId'];
    } else {
      throw Exception('${supplement.supplementName} 등록을 실패하였습니다.');
    }
  }

  // TODO 나의 영양제 삭제 api 연동
  Future<void> deleteSupplement(int supplementId) async {
    final url = Uri.parse('$baseUrl/supplement/intake/$supplementId');
    Response res = await delete(url);

    if (res.statusCode == 200) {
      print('사용자의 영양제가 삭제되었습니다.');
    } else {
      throw '사용자의 영양제 삭제를 실패하였습니다.';
    }
  }
}
