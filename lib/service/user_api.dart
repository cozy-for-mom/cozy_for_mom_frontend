import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/baby_register_screen.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:cozy_for_mom_frontend/service/user/user_local_storage_service.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserApiService extends ChangeNotifier {
  final tokenManager = TokenManager.TokenManager();

  Future<Map<String, dynamic>> getUserInfo() async {
    UserLocalStorageService storageService =
        await UserLocalStorageService.getInstance();
    try {
      final headers = await getHeaders();
      final url = Uri.parse('$baseUrl/me');
      Response res = await get(url, headers: headers);
      if (res.statusCode == 200) {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        final userData = body['data'];
        List<dynamic> babyProfilesData = userData['babyProfile'];
        List<BabyProfile> babyProfiles = babyProfilesData.map((babyProfile) {
          return BabyProfile.fromJson(babyProfile);
        }).toList();
        BabyProfile recentBabyProfile =
            BabyProfile.fromJson(userData['recentBabyProfile']);

        String name = userData['name'];
        String nickname = userData['nickname'];
        String introduce = userData['introduce'] ?? '';
        String? imageUrl = userData['imageUrl'];
        String birth = userData['birth'];
        String email = userData['email'];
        int dDay = userData['dDay'];

        storageService.setUser(
          User(
            name: name,
            nickname: nickname,
            introduce: introduce,
            birth: birth,
            email: email,
            babyProfile: recentBabyProfile,
            recentBabyProfile: recentBabyProfile,
            dDay: dDay,
          ),
        );

        return {
          'name': name,
          'nickname': nickname,
          'introduce': introduce,
          'imageUrl': imageUrl,
          'birth': birth,
          'email': email,
          'babyProfiles': babyProfiles,
          'recentBabyProfile': recentBabyProfile,
          'dDay': dDay
        };
      } else {
        throw Exception('Failed to load user info: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> modifyUserProfile(String name, String nickname, String introduce,
      String? imageUrl, String birth, String email) async {
    final headers = await getHeaders();
    final url = Uri.parse('$baseUrl/me');
    Map data = {
      'name': name,
      'nickname': nickname,
      'introduce': introduce,
      'image': imageUrl,
      'birth': birth,
      'email': email
    };
    final Response response =
        await put(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('$name 산모 프로필 수정을 실패하였습니다.');
    }
  }

  Future<void> modifyMainBaby(int id) async {
    final url = Uri.parse('$baseUrl/me/baby/recent');
    final headers = await getHeaders();
    Map data = {'babyProfileId': id};
    final Response response =
        await post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('$id 메인 태아 프로필 변경을 실패하였습니다.');
    }
  }

  Future<Map<String, dynamic>> getBabyProfile(int babyProfileId) async {
    try {
      final url = Uri.parse('$baseUrl/baby/$babyProfileId');
      final headers = await getHeaders();
      Response res = await get(url, headers: headers);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        String dueAt = body['data']['dueAt'];
        String? profileImageUrl = body['data']['profileImageUrl'];
        List<BabyForRegister> babies =
            (body['data']['babies'] as List<dynamic>).map((baby) {
          return BabyForRegister(name: baby['name'], gender: baby['gender']);
        }).toList();
        return {
          'dueAt': dueAt,
          'profileImageUrl': profileImageUrl,
          'babies': babies
        };
      } else {
        throw Exception('$babyProfileId 태아 프로필 조회 실패: ${res.statusCode}');
      }
    } catch (e) {
      // 에러 처리
      print(e);
      rethrow;
    }
  }

  Future<void> addBabyProfile(String dueAt, String? profileImageUrl,
      List<BabyForRegister> babies) async {
    final url = Uri.parse('$baseUrl/baby');
    final headers = await getHeaders();
    final Response response = await post(url,
        headers: headers,
        body: jsonEncode({
          'dueAt': dueAt,
          'profileImageUrl': profileImageUrl,
          'babies': babies.map((e) => e.toJson()).toList(),
        }));

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('태아 추가를 실패하였습니다.');
    }
  }

  Future<void> modifyBabyProfile(int babyProfileId, String dueAt,
      String? profileImageUrl, List<BabyForRegister> babies) async {
    final url = Uri.parse('$baseUrl/baby/$babyProfileId');
    final headers = await getHeaders();
    final Response response = await put(url,
        headers: headers,
        body: jsonEncode({
          'dueAt': dueAt,
          'profileImageUrl': profileImageUrl,
          'babies': babies.map((e) => e.toJson()).toList(),
        }));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('태아 수정을 실패하였습니다.');
    }
  }

  Future<void> deleteBabyProfile(int babyProfileId) async {
    final url = Uri.parse('$baseUrl/baby/$babyProfileId');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);
    if (res.statusCode == 200) {
      print('$babyProfileId 태아 프로필이 삭제되었습니다.');
    } else {
      throw '$babyProfileId 태아 프로필 삭제를 실패하였습니다.';
    }
  }

  Future<void> logOut() async {
    final url = Uri.parse('$baseUrl/user/logout');
    final headers = await getHeaders();
    Response res = await delete(url, headers: headers);
    Map<String, dynamic> responseData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      await tokenManager.deleteToken();
      final id = responseData['data']['userId'];
      print('user $id 회원이 로그아웃되었습니다.');
    } else {
      throw '로그아웃을 실패하였습니다.';
    }
  }
}

class Baby {
  final String name;
  final String gender;

  Baby({required this.name, required this.gender});
}
