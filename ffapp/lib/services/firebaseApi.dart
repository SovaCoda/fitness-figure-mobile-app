import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Logger logger = Logger();

  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    logger.i('user granted permission: ${settings.authorizationStatus}');
    final token = await _firebaseMessaging.getToken();
    logger.i('FirebaseMessaging token: $token');
  }
}