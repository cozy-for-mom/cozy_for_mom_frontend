import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var flutterResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 알림 권한 요청
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .sound, .badge],
      completionHandler: { granted, error in
        if granted {
          DispatchQueue.main.async {
            application.registerForRemoteNotifications()
          }
        } else {
            print("User did not grant permission: \(String(describing: error?.localizedDescription))")
          }
      }
    )
    UNUserNotificationCenter.current().delegate = self

    // Flutter와의 통신 채널 설정
    let controller = window?.rootViewController as! FlutterViewController
    let deviceTokenChannel = FlutterMethodChannel(name: "com.cozyformom.deviceTokenChannel",
                                                  binaryMessenger: controller.binaryMessenger)
    deviceTokenChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getDeviceToken" {
        self.flutterResult = result
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 디바이스 토큰 얻기
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("Device Token: \(token)")

    // Flutter로 디바이스 토큰 전달
    if let result = flutterResult {
      result(token)
      flutterResult = nil
    }
  }

  // 디바이스 토큰 얻기 실패
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications with error: \(error)")
  }
}
