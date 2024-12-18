import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final _androidChanel = const AndroidNotificationChannel(
    'channel_id',
    'channel_name',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  NotificationService(this.flutterLocalNotificationsPlugin);

  Future<void> initialize() async {
    await _initializeLocal();
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const platform = NotificationDetails(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  Future<void> _initializeLocal() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification Received: ${details.payload}');
      },
    );

    final androidPlatform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    androidPlatform?.createNotificationChannel(_androidChanel);
  }
}
