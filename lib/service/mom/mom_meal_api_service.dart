import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/meal_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MealApiService extends ChangeNotifier {
  Future<List<dynamic>> getMeals(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/meal?date=$formattedDate');
      final headers = await getHeaders();
      // TODO api 실제 테스트 시 위의 코드 주석 처리 및 아래 코드 주석 해제
      Response res = await get(url, headers: headers);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<dynamic> mealsData = body['data']['mealRecordList'];
        List<MealModel> meals = mealsData.map((meal) {
          return MealModel.fromJson(meal);
        }).toList();
        return meals;
      } else {
        throw Exception('HTTP 요청 실패: ${res.statusCode}');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  Future<int> recordMeals(
      DateTime dateTime, String mealType, String? imageUrl) async {
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    final url = Uri.parse('$baseUrl/meal');
    final headers = await getHeaders();
    Map data = {
      'datetime': formattedDate,
      'mealType': mealType,
      'mealImageUrl': imageUrl
    };

    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return responseData['data']['id'];
    } else {
      throw Exception('$dateTime $mealType 식사 기록 등록을 실패하였습니다.');
    }
  }

  Future<int> modifyMeals(
      int id, DateTime dateTime, String mealType, String? imageUrl) async {
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    final url = Uri.parse('$baseUrl/meal/$id');
    final headers = await getHeaders();
    Map data = {
      'datetime': formattedDate,
      'mealType': mealType,
      'mealImageUrl': imageUrl
    };

    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData['data']['id'];
    } else {
      throw Exception('$dateTime $mealType 식사 기록 수정을 실패하였습니다.');
    }
  }

  Future<void> deleteMeal(int id) async {
    final url = Uri.parse('$baseUrl/meal/$id');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);
    if (res.statusCode == 204) {
      print('$id 식사 기록이 삭제되었습니다.');
    } else {
      throw '$id 식사 기록 삭제를 실패하였습니다.';
    }
  }
}
