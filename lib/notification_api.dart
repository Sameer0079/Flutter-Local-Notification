// import 'package:app_settings/app_settings.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';

class NotificationApi {
  static Future<bool?> checkPermission() => notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .areNotificationsEnabled();

  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    bool? permissionCheck = await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .areNotificationsEnabled();

    if (permissionCheck == null) {
      notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }

    AndroidInitializationSettings androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    DarwinInitializationSettings iosInitialize =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    await notificationsPlugin.initialize(initializationSettings);
  }

  // static Future sendNotification({id=0, required String title, required String body, var payload}) async{
  //   AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
  //     'channal id',
  //     'channel name',
  //     channelDescription: 'channel description',
  //     playSound: true,
  //     importance: Importance.max,
  //     priority: Priority.high
  //   );

  //   var notificiona
  // }

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            priority: Priority.max,
            importance: Importance.high),
        iOS: DarwinNotificationDetails());
  }

  static Future<void> sendNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload,
  }) async {
    bool? chkPermission = await checkPermission();
    log(chkPermission.toString());
    if (chkPermission != null && chkPermission) {
      notificationsPlugin.show(id, title, body, await _notificationDetails(),
          payload: payload);
    }
  }
}
