import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:http/http.dart';

class BabyGrowthApiService {
  Future<BabyProfileGrowth> createBabyProfileGrowth(
      BabyProfileGrowth growth) async {
    final url = Uri.parse("/v1/growth");
    final headers = await getHeaders();
    final response = await post(
      url,
      headers: headers,
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
    final headers = await getHeaders();
    if (lastId != null) urlString += '&lastId=null';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

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
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

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
