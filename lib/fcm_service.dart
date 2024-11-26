import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';
import 'package:flutter_pet_shop_app/data/repository/device_repository.dart';
import 'package:flutter_pet_shop_app/domain/usecases/device_usecase.dart';
import 'package:flutter_pet_shop_app/main.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  navigatorKey.currentState?.pushNamed(RouteName.explore);
}

class FCMService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _androidChannel = AndroidNotificationChannel(
    'test_channel',
    'Test Channel',
    description: 'This is a test notification channel.',
    importance: Importance.defaultImportance,
  );

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    final deviceId = await _getDeviceId();
    if (deviceId != null) {
      await DeviceUsecase(
              deviceRepositoryImpl: DeviceRepositoryImpl(
                  firebaseDataSourceImpl: FirebaseDataSourceImpl()))
          .putDeviceToken(deviceId, fCMToken!);
      initPushNotification();
      initLocalNotifications();
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      navigatorKey.currentState?.pushNamed(RouteName.explore);
    } else {
      return;
    }
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, sound: true, badge: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) {
        return;
      }

      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: "@drawable/notification_icon")),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android =
        AndroidInitializationSettings("@drawable/notification_icon");
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (notificationResponse) {
      var payload = notificationResponse.payload;
      if (payload != null) {
        handleMessage(RemoteMessage.fromMap(jsonDecode(payload)));
      }
    });

    final platform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<String?> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    } else {
      return null;
    }
  }
}
