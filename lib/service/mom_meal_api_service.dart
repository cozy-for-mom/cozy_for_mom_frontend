import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/meal_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MealApiService extends ChangeNotifier {
  Future<List<dynamic>> getMeals(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = Uri.parse('$baseUrl/meal?date=$formattedDate');
      // TODO api 실제 테스트 시 위의 코드 주석 처리 및 아래 코드 주석 해제
      // Response res = await get(url);
      String jsonString =
          await rootBundle.loadString('assets/test_json/meal.json');

      // TODO 상태 코드에 따른 에러 처리 추가
      // if (jsonString.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(jsonString);
      List<dynamic> mealsData = body['data']['mealRecordList'];
      List<MealModel> meals = mealsData.map((meal) {
        return MealModel.fromJson(meal);
      }).toList();

      return meals;
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  // TODO 식단 기록 api 연동
  Future<MealModel> recordMeals(
      DateTime dateTime, MealType mealType, String imageUrl) async {
    final formattedDate =
        DateFormat('yyyy-MM-dd\'H\'HH:mm:ss').format(dateTime);
    final url = Uri.parse('$baseUrl/meal');
    Map data = {
      'date': formattedDate,
      'mealType': mealType,
      'mealImageUrl': imageUrl
    };

    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return MealModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('$dateTime $mealType 식사 기록 등록을 실패하였습니다.');
    }
  }

  // TODO 식사 기록 수정 api 연동
  Future<MealModel> modifyMeals(
      DateTime dateTime, MealType mealType, String imageUrl) async {
    final formattedDate =
        DateFormat('yyyy-MM-dd\'H\'HH:mm:ss').format(dateTime);
    // TODO mealId 받아서 url '$baseUrl/meal/$id'로 수정하기
    final url = Uri.parse('$baseUrl/meal');
    Map data = {
      'datetime': formattedDate,
      'type': mealType,
      'mealImageUrl': imageUrl
    };

    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return MealModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('$dateTime $mealType 식사 기록 수정을 실패하였습니다.');
    }
  }

  // TODO 섭취 식사 기록 삭제 api 연동
  Future<void> deleteWeight(DateTime dateTime) async {
    // TODO mealId 받아서 url '$baseUrl/meal/$id'로 수정하기
    final url = Uri.parse('$baseUrl/meal');
    Response res = await delete(url);

    if (res.statusCode == 200) {
      print('$dateTime 식사 기록이 삭제되었습니다.');
    } else {
      throw '$dateTime 식사 기록 삭제를 실패하였습니다.';
    }
  }
}
