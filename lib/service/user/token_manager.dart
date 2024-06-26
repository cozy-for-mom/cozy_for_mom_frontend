import 'package:cozy_for_mom_frontend/service/user/oauth_api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  TokenManager._internal();

  factory TokenManager() {
    return _instance;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  Future<void> setToken(String accessToken) async {
    await _storage.write(key: accessTokenKey, value: accessToken);

  }

  Future<int> getUserId() async {
    return await _storage.read(key: accessTokenKey).then((value) => 
        int.parse(JwtDecoder.decode(value!)['info']['userId']));
  }

  Future<UserType> getUserType() async {
    return _storage.read(key: accessTokenKey).then((value) =>
        UserType.findByString(JwtDecoder.decode(value!)['info']['role']));
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: accessTokenKey);
  }
}

/// access token key for secure storage
const accessTokenKey = 'access_token';

/// refresh token key for secure storage
const refreshTokenKey = 'refresh_token';
