import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:udetxen/features/auth/services/auth_service.dart';
import 'package:udetxen/features/auth/services/jwt_service.dart';
import 'package:udetxen/features/profile/services/profile_service.dart';
import 'package:udetxen/shared/services/connectivity_service.dart';
import 'package:udetxen/shared/services/theme_service.dart';
import '../services/notification_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin());

  getIt.registerSingleton<NotificationService>(
      NotificationService(getIt<FlutterLocalNotificationsPlugin>()));

  getIt.registerSingleton<ConnectivityService>(
      ConnectivityService(Connectivity()));

  getIt.registerSingleton<ThemeService>(ThemeService());

  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<ProfileService>(ProfileService());
  getIt.registerSingleton<JwtService>(JwtService(getIt<SharedPreferences>()));
}
