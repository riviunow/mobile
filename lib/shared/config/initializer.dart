import 'package:rvnow/shared/config/service_locator.dart';
import 'package:rvnow/shared/services/background_service.dart';

import '../services/connectivity_service.dart';
import '../services/notification_service.dart';
import '../services/translation_service.dart';

Future<void> initialize() async {
  await getIt<ConnectivityService>().initialize();

  await getIt<NotificationService>().initialize();

  await getIt<TranslationService>().initialize();

  await getIt<BackgroundService>().initialize();
}
