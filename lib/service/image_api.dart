import 'dart:convert';

import 'package:cozy_for_mom_frontend/service/base_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';

class ImageApiService {
  Future<String?> uploadImage(XFile imageFile) async {
    var url = '$baseUrl/image';
    var request = MultipartRequest('POST', Uri.parse(url));

    request.files.add(await MultipartFile.fromPath('image', imageFile.path,
        contentType: MediaType('image', 'jpg')));
    final response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode(await response.stream.bytesToString());
      String imageUrl = responseData['data']['imageUrl'];
      return imageUrl;
    } else {
      throw Exception('이미지 등록을 실패하였습니다.');
    }
  }
}
