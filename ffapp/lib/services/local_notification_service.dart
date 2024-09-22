import 'package:ffapp/services/auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // to do remove awesome notifications
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz; 

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  SharedPreferences? sharedPrefs;
  bool hasScheduledOfflineNotification = true;
  DateTime? lastNotificationTimestamp;

  Future<bool> isReadyForNotification () async {
    sharedPrefs = await SharedPreferences.getInstance();
    String? prefsLastOfflineNotificationTime = sharedPrefs!.getString('lastOfflineNotificationTime');
    if(prefsLastOfflineNotificationTime == null) {return true;}
    else {
      lastNotificationTimestamp = DateTime.parse(prefsLastOfflineNotificationTime);
      Duration difference = lastNotificationTimestamp!.difference(DateTime.now().toUtc());
      if(difference.inHours.abs() > 24) {
        return true;
      } else {return false;}
    }
  }

  Future initNotifications() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('fflogo');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("America/Detroit"));

    var iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
      
      var initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
      await notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  notificationDetails () {
    return const NotificationDetails(android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max), iOS: DarwinNotificationDetails());
  }

  Future showNotification ({int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }

  Future scheduleOfflineNotification({int id = 0, String? title, required String body, String? payload}) async {
    if (!await isReadyForNotification()) {logger.e("A notification has already been sent today"); return;}
    await notificationsPlugin.zonedSchedule(
    0,
    title,
    body,
    tz.TZDateTime.now(tz.local).add(const Duration(hours: 2)),
    await notificationDetails(),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
    sharedPrefs!.setString("lastOfflineNotificationTime", DateTime.now().toUtc().toString());
  }
}