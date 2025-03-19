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
  final android = const AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );
  final ios = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  late final NotificationDetails platform;

  NotificationService(this.flutterLocalNotificationsPlugin) {
    platform = NotificationDetails(android: android, iOS: ios);
  }

  Future<void> initialize() async {
    await _initializeLocal();
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
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
    final ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // print('Notification received in foreground: $title $body');
      },
    );

    final settings = InitializationSettings(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        // print('Notification Clicked: ${details.payload}');
      },
    );

    // Request iOS notification permissions at runtime
    final iosPlatform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await iosPlatform?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    final androidPlatform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    androidPlatform?.createNotificationChannel(_androidChanel);
  }
}
