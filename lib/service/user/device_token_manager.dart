import 'package:flutter/services.dart';

class DeviceTokenManager {
  static final DeviceTokenManager _instance = DeviceTokenManager._internal();
  static const MethodChannel _channel =
      MethodChannel('com.cozyformom.deviceTokenChannel');

  String? _deviceToken;

  factory DeviceTokenManager() {
    return _instance;
  }

  DeviceTokenManager._internal();

  Future<void> initialize() async {
    _deviceToken = await _getDeviceTokenFromNative();
  }

  Future<String?> _getDeviceTokenFromNative() async {
    var token;
    try {
      token = await _channel
          .invokeMethod('getDeviceToken')
          .timeout(const Duration(milliseconds: 500));
    } catch (e) {
      print("exception 발생 $e");
      return null;
    }

    return token;
  }

  String? get deviceToken => _deviceToken;
}
