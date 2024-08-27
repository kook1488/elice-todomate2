import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

//////////////////////////////////////////////
// kook[4] 알림 설정및 전송
  static Future<void> sendNicknameChangeNotification({
    required String oldNickname,
    required String newNickname,
    required String friendId,
  }) async {
    // 알림 생성
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'nickname_change_channel',
      'Nickname Change',
      channelDescription: '닉네임 변경 알림',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    // 알림 내용 수정
    String notificationBody = ' $newNickname로 닉네임을 변경하였습니다.';
    // 알림 전송
    await _notificationsPlugin.show(
      0,
      '닉네임 변경',
      notificationBody,
      platformDetails,
    );

    // 로컬 저장소에 메시지 저장
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];
    notifications.add('$oldNickname에서 $newNickname으로 닉네임이 변경되었습니다.');
    await prefs.setStringList('notifications', notifications);
  }

  // 저장된 알림 가져오기
  static Future<List<String>> getStoredNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('notifications') ?? [];
  }

  // 알림 지우기
  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
  }

  //////////////////////////////////////////////
  //알림기능 시작
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 초기화 설정
    const DarwinInitializationSettings
        initializationSettingsDarwin = // 여기 이름 수정
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin, // 수정된 부분
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS 알림 세부사항
    const DarwinNotificationDetails darwinPlatformChannelSpecifics = // 여기 이름 수정
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics, // 수정된 부분
    );

    await _notificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }
}
