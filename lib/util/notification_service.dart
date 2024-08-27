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

    // 알림 전송
    await _notificationsPlugin.show(
      0,
      '닉네임 변경',
      '$oldNickname에서 $newNickname으로 닉네임이 변경되었습니다.',
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
}
