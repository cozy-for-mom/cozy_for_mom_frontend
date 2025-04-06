import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;
import 'package:cozy_for_mom_frontend/utils/http_response_handlers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';

class ImageApiService {
  Future<String?> uploadImage(BuildContext context, XFile imageFile) async {
    var url = '$baseUrl/image';
    final tokenManager = TokenManager.TokenManager();
    String? token = await tokenManager.getToken(); // 비동기적으로 토큰을 받아옴
    var request = MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await MultipartFile.fromPath('image', imageFile.path,
        contentType: MediaType('image', 'jpg')));
    final res = await request.send();
    if (res.statusCode == 200) {
      Map<String, dynamic> resData =
          jsonDecode(await res.stream.bytesToString());
      String imageUrl = resData['data']['imageUrl'];
      return imageUrl;
    } else {
      if (context.mounted) {
        if (context.mounted) {
          handleHttpResponse(res.statusCode, context, '이미지 등록에 실패하였습니다.');
        }
      }
      return null;
      // throw Exception('이미지 등록을 실패하였습니다.');
    }
  }
}
