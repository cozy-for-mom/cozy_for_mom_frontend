import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceTokenManager {
  static final DeviceTokenManager _instance = DeviceTokenManager._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const MethodChannel _channel =
      MethodChannel('com.cozyformom.deviceTokenChannel');

  String? _deviceToken;

  factory DeviceTokenManager() {
    return _instance;
  }

  DeviceTokenManager._internal();

  Future<Map<String, dynamic>> initialize() async {
    var result = await _getDeviceTokenFromNative();
    if (result != null && result['token'] != null) {
      await saveDeviceToken(result['token']);
    }
    return result ?? {};
  }

  Future<Map<String, dynamic>?> _getDeviceTokenFromNative() async {
    try {
      final result = await _channel.invokeMethod('getDeviceToken');
      bool permissionGranted = result['permissionGranted'];
      String token = result['token'];
      return {'permissionGranted': permissionGranted, 'token': token};
    } catch (e) {
      print("exception 발생 $e");
      return null;
    }
  }

  Future<void> saveDeviceToken(String token) async {
    await _storage.write(key: 'deviceToken', value: token);
  }

  Future<String?> getDeviceToken() async {
    return await _storage.read(key: 'deviceToken');
  }

  String? get deviceToken => _deviceToken;
}
