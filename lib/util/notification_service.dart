// notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> sendNicknameChangeNotification(
      {required String oldNickname, required String newNickname}) async {
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

    // 알림 전송
    await _notificationsPlugin.show(
      0,
      '닉네임 변경',
      '$oldNickname에서 $newNickname으로 닉네임이 변경되었습니다.',
      platformDetails,
    );

    // shared_preferences에 변경 사항 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_nickname', newNickname);
  }

  // 마지막으로 저장된 닉네임 가져오기
  static Future<String?> getLastNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_nickname');
  }
}
