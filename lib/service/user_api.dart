import 'dart:convert';

import 'package:cozy_for_mom_frontend/model/user_model.dart';
import 'package:cozy_for_mom_frontend/screen/mypage/baby_register_screen.dart';
import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/base_headers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserApiService extends ChangeNotifier {
  Future<Map<String, dynamic>> getUserInfo() async {
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

  Future<void> addBabies(String dueAt, String? profileImageUrl, List<BabyForRegister> babies) async {
    final url = Uri.parse('$baseUrl/baby');
    final headers = await getHeaders();
    final Response response =
        await post(url, headers: headers,     body: jsonEncode({
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
}

class Baby {
  final String name;
  final String gender;

  Baby({required this.name, required this.gender});
}