import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:periodnpregnancycalender/firebase_options.dart';
import 'package:flutter/foundation.dart';

import 'package:periodnpregnancycalender/app/services/services.dart';

class FirebaseNotificationService {
  final ApiService _apiService = ApiService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(FirebaseNotificationService.showFlutterNotification);
    await FirebaseNotificationService.setupFlutterNotifications();
  }

  Future<void> storeFcmToken(int userId) async {
    String? token = await _firebaseMessaging.getToken();
    assert(token != null);
    if (token != null) {
      await _apiService.storeFcmToken(token, userId);
      print("FirebaseMessaging token: $token");
    }
  }

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      print("flutterLocalNotificationsPlugin.show called!");
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    } else {
      print("flutterLocalNotificationsPlugin.show not called!");
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print("message data: ${message.data}");

  //Import your firebase config
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseNotificationService.setupFlutterNotifications();
  FirebaseNotificationService.showFlutterNotification(message);
}
