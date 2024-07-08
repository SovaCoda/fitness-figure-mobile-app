import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('fflogo');

    var iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
      
      var initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
      await notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  notificationDetails () {
    return const NotificationDetails(android: AndroidNotificationDetails('channelId', 'channelName'), iOS: DarwinNotificationDetails());
  }

  Future showNotification ({int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }
}