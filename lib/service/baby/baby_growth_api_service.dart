import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:http/http.dart';

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
}
