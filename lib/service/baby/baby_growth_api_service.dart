import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:http/http.dart';

const baseUrl = "http://43.202.14.104:8080/api/v1"; // TODO remove

class BabyGrowthApiService {
  Future<BabyProfileGrowth> createBabyProfileGrowth(
      BabyProfileGrowth growth) async {
    final url = Uri.parse("/v1/growth");
    final response = await post(
      url,
      body: jsonEncode(growth.toJson()),
    );

    if (response.statusCode == 200) {
      return BabyProfileGrowth.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('성장 보고서 저장 실패');
    }
  }

  Future<List<BabyProfileGrowth>> getBabyProfileGrowths(
    int? lastId,
    int size,
  ) async {
    var urlString = '$baseUrl/growth/board?size=$size';
    if (lastId != null) urlString += '&lastId=null';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body['data']['list'];
      List<BabyProfileGrowth> growths = data.map((growth) {
        return BabyProfileGrowth.fromJson(growth);
      }).toList();
      return growths;
    } else {
      throw Exception('성장 보고서 목록 조회 실패');
    }
  }

  Future<BabyProfileGrowth> getBabyProfileGrowth(
    int id,
  ) async {
    var urlString = '$baseUrl/growth/$id?userId=1'; // TODO userId 넣는 방식 수정
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      dynamic data = body['data'];
      BabyProfileGrowth growth = BabyProfileGrowth.fromJson(data);
      return growth;
    } else {
      throw Exception('성장 보고서 조회 실패 - id: $id');
    }
  }
}
