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
    try {
      if (deviceToken != null) return deviceToken;
      final String? token = await _channel.invokeMethod('getDeviceToken') ??
          DeviceTokenManager().deviceToken;
      return token;
    } on PlatformException catch (e) {
      print("Failed to get device token: '${e.message}'.");
      return null;
    } catch (e) {
      print("An unexpected error occurred: ${e.toString()}");
      return null;
    }
  }
  // Future<String?> _getDeviceTokenFromNative() async {
  //   try {
  //     if (_deviceToken != null) return _deviceToken;
  //     final String? token = await _channel.invokeMethod('getDeviceToken');
  //     print(token);
  //     if (token != null && token.isNotEmpty) {
  //       _deviceToken = token;
  //     }
  //     return _deviceToken;
  //   } on PlatformException catch (e) {
  //     print("[PlatformException] Failed to get device token: '${e.message}'.");
  //     return null;
  //   } catch (e) {
  //     print("An unexpected error occurred: ${e.toString()}");
  //     return null;
  //   }
  // }

  String? get deviceToken => _deviceToken;
}
