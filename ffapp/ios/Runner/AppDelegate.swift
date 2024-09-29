import Flutter
import UIKit
import flutter_local_notifications
import ActivityKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let liveActivityManager: LiveActivityManager = LiveActivityManager()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      func applicationWillTerminate(_ application: UIApplication) {
          stopAllLiveActivities()
      }
      
      func stopAllLiveActivities() {
              Task {
                  // Fetch all active Live Activities
                  let activities = await Activity<StopwatchDIWidgetAttributes>.activities
                  
                  // Iterate and stop each activity
                  for activity in activities {
                      await activity.end(dismissalPolicy: .immediate)
                  }
              }
          }
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
      }

      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let diChannel =  FlutterMethodChannel(name: "LI", binaryMessenger: controller.binaryMessenger)

          diChannel.setMethodCallHandler({ [weak self] (
                 call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                      switch call.method {
                      case "startLiveActivity":
                          self?.liveActivityManager.startLiveActivity(
                              data: call.arguments as? Dictionary<String,Any>,
                              result: result)
                          break
                          
                      case "updateLiveActivity":
                          self?.liveActivityManager.updateLiveActivity(
                              data: call.arguments as? Dictionary<String,Any>,
                              result: result)
                          break
                          
                      case "stopLiveActivity":
                          self?.liveActivityManager.stopLiveActivity(result: result)
                          break
                          
                      default:
                          result(FlutterMethodNotImplemented)
                  }
             })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
