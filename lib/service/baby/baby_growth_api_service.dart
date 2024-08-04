import 'dart:convert';

import 'package:cozy_for_mom_frontend/common/extension/pair.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/service/user/user_local_storage_service.dart';
import 'package:http/http.dart';

class BabyGrowthApiService {
  Future<int> registerBabyProfileGrowth(BabyProfileGrowth growth) async {
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

  Future<Pair<List<BabyProfileGrowth>, DateTime?>> getBabyProfileGrowths(
    int? lastId,
    int size,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    print(babyProfileId);
    var urlString = '$baseUrl/growth/$babyProfileId/board?size=$size';
    final headers = await getHeaders();
    if (lastId != null) urlString += '&lastId=null';
    final url = Uri.parse(urlString);
    dynamic response;
    response = await get(url, headers: headers);
    // print(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = body['data']['list'];
      DateTime? nextExaminationDate = body['data']['nextExaminationDate'] == ""
          ? null
          : DateTime.parse(body['data']['nextExaminationDate']);

      List<BabyProfileGrowth> growths = data.map((growth) {
        print(growth);
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
    print(utf8.decode(response.bodyBytes));

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

  Future<void> registerNotificationExaminationDate(
    String examinationAt,
    List<String> notificationOptions,
  ) async {
    UserLocalStorageService userStorageService =
        await UserLocalStorageService.getInstance();
    final babyProfileId = await userStorageService.getBabyProfileId();
    var urlString = '$baseUrl/notification/examination';
    final headers = await getHeaders();
    final url = Uri.parse(urlString);
    dynamic response;
    print({
      'babyProfileId': babyProfileId,
      'examinationAt': examinationAt,
      'notifyAt': notificationOptions,
    });
    response = await post(url,
        headers: headers,
        body: jsonEncode({
          'babyProfileId': babyProfileId,
          'examinationAt': examinationAt,
          'notifyAt': notificationOptions,
        }));

    if (response.statusCode == 201) {
    } else {
      throw Exception('다음검진일 설정 실패');
    }
  }

  Future<void> deleteBabyProfileGrowth(int id) async {
    final url = Uri.parse('$baseUrl/growth/$id');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);
    if (res.statusCode == 204) {
      print('$id 성장보고서 기록이 삭제되었습니다.');
    } else {
      throw '$id 성장보고서 기록 삭제를 실패하였습니다.';
    }
  }
}
