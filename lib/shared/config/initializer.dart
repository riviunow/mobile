import 'package:udetxen/shared/config/service_locator.dart';

import '../services/connectivity_service.dart';
import '../services/notification_service.dart';

Future<void> initialize() async {
  await getIt<ConnectivityService>().initialize();

  await getIt<NotificationService>().initialize();
}
