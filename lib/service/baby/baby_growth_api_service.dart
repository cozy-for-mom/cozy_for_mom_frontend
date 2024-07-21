import 'dart:convert';

import 'package:cozy_for_mom_frontend/common/extension/pair.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/service/user/user_local_storage_service.dart';
import 'package:http/http.dart';

class BabyGrowthApiService {
  Future<int> registerBabyProfileGrowth(
      BabyProfileGrowth growth) async {
    final headers = await getHeaders();
    if (growth.id != null) {
    final url = Uri.parse("$baseUrl/growth/${growth.id}");
  final response = await put(
      url,
      headers: headers,
      body: jsonEncode(growth.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)['data']['growthReportId'];
    } else {
      throw Exception('성장 보고서 저장 실패');
    }
    } else {
    final url = Uri.parse("$baseUrl/growth");
      final response = await post(
      url,
      headers: headers,
      body: jsonEncode(growth.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)['data']['growthReportId'];
    } else {
      throw Exception('성장 보고서 저장 실패');
    }
    }
    
  }

  Future<Pair<List<BabyProfileGrowth>, DateTime>> getBabyProfileGrowths(
    int? lastId,
    int size,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    var urlString = '$baseUrl/growth/$babyProfileId/board?size=$size';
    final headers = await getHeaders();
    if (lastId != null) urlString += '&lastId=null';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body['data']['list'];
      DateTime nextExaminationDate =
          DateTime.parse(body['data']['nextExaminationDate']);

      List<BabyProfileGrowth> growths = data.map((growth) {
        return BabyProfileGrowth.fromJson(growth, babyProfileId!);
      }).toList();
      return Pair(growths, nextExaminationDate);
    } else {
      throw Exception('성장 보고서 목록 조회 실패');
    }
  }

  Future<BabyProfileGrowth> getBabyProfileGrowth(
    int id,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    var urlString = '$baseUrl/growth/$id';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      dynamic data = body['data'];
      BabyProfileGrowth growth =
          BabyProfileGrowth.fromJson(data, babyProfileId!);
      return growth;
    } else {
      throw Exception('성장 보고서 조회 실패 - id: $id');
    }
  }
}
