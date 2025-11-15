import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static String? fcmToken;

  static Future<void> init() async {
    developer.log('Initializing NotificationService...', name: 'FCM');

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission();
    developer.log('Permission status: ${settings.authorizationStatus}', name: 'FCM');

    // Get token
    final token = await messaging.getToken();
    fcmToken = token;
    developer.log("FCM Token: $token", name: 'FCM');

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    final bool? initialized = await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        developer.log('Notification tapped: ${details.payload}', name: 'FCM');
      },
    );

    developer.log('Local notifications initialized: $initialized', name: 'FCM');
  }

  static Future<void> showNotification(RemoteMessage message) async {
    developer.log('--- Showing Notification ---', name: 'FCM');
    developer.log('Message ID: ${message.messageId}', name: 'FCM');
    developer.log('Data: ${message.data}', name: 'FCM');
    developer.log('Title: ${message.notification?.title}', name: 'FCM');
    developer.log('Body: ${message.notification?.body}', name: 'FCM');

    // Debug print có màu sắc
    if (kDebugMode) {
      print('🔔 === FCM Notification ===');
      print('📋 Title: ${message.notification?.title ?? 'No Title'}');
      print('📝 Body: ${message.notification?.body ?? 'No body'}');
      print('📦 Data: ${message.data}');
      print('========================');
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    try {
      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No body',
        generalNotificationDetails,
        payload: message.data.toString(),
      );
      developer.log('✅ Notification shown successfully', name: 'FCM');
    } catch (e) {
      developer.log('❌ Error showing notification: $e', name: 'FCM', error: e);
    }
  }
}