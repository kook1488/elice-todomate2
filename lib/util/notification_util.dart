import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtil {
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  // Singleton pattern to ensure a single instance
  static final NotificationUtil _instance = NotificationUtil._internal();

  factory NotificationUtil() => _instance;

  NotificationUtil._internal();

  Future<void> initialize() async {
    AndroidInitializationSettings android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
  }

  void requestNotificationPermission() {
    _local.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.
    requestPermissions(
      alert: true,
      badge: true,
      sound: true,);
  }


  Future<void> showNotification(String title, String body) async {
    const NotificationDetails details = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,

      ),
      android: AndroidNotificationDetails(
        "chat", //채널 아이디 별로 알림 특성 설정 가능(방 같은 개념)
        "chatroom", //채널의 용도를 설명하는 이름
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    //앞의 int값이 알림 고유 번호 -> 상수값 넣으면 한개만 덮어씀
    await _local.show(0, title, body, details);
  }
}