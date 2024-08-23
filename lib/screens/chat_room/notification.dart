import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todomate/models/chat_room_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notifications.initialize(
      initializationSettings,
    );
  }

  static requestNotificationPermission() {
    _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> showNotification(
      ChatRoomModel chatRoom, String title, String content) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    DateTime startDate = DateTime.parse(chatRoom.startDate);

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );

    await _notifications.show(
      chatRoom.id!,
      '${chatRoom.name} 채팅방 $title',
      content,
      notificationDetails,
    );

    await _notifications.zonedSchedule(
      chatRoom.id!,
      '${chatRoom.name} 채팅방이 시작되었습니다.',
      '',
      tz.TZDateTime(tz.local, startDate.year, startDate.month, startDate.day,
          startDate.hour, startDate.minute, startDate.second),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
