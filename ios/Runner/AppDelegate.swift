import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var deviceTokenString: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        let deviceTokenChannel = FlutterMethodChannel(name: "com.cozyformom.deviceTokenChannel", binaryMessenger: controller.binaryMessenger)

        deviceTokenChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getDeviceToken" {
                self?.requestNotificationPermission(application: application, result: result)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func requestNotificationPermission(application: UIApplication, result: @escaping FlutterResult) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    application.registerForRemoteNotifications()
                }
                // Combine the permission status and token into one response
                let response = [
                    "permissionGranted": granted,
                    "token": self.deviceTokenString ?? ""
                ]
                result(response)
            }
        }
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        self.deviceTokenString = tokenParts.joined()
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }
}

