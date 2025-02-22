import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rvnow/features/auth/services/auth_service.dart';
import 'package:rvnow/features/auth/services/jwt_service.dart';
import 'package:rvnow/features/creating/knowledge/services/knowledge_service.dart'
    as creating;
import 'package:rvnow/features/creating/publication_request/services/publication_request_service.dart';
import 'package:rvnow/features/exploring/knowledge/services/knowledge_service.dart';
import 'package:rvnow/features/exploring/knowledge/services/knowledge_topic_service.dart';
import 'package:rvnow/features/exploring/knowledge/services/knowledge_type_service.dart';
import 'package:rvnow/features/exploring/subject/services/subject_service.dart';
import 'package:rvnow/features/exploring/track/services/track_service.dart';
import 'package:rvnow/features/learning/knowledge_learning/services/learning_service.dart';
import 'package:rvnow/features/learning/learn_and_review/services/learn_and_review_service.dart';
import 'package:rvnow/features/learning/learning_list/services/learning_list_service.dart';
import 'package:rvnow/features/profile/services/profile_service.dart';
import 'package:rvnow/features/migration/services/knowledge_topic_service.dart'
    as migration;
import 'package:rvnow/features/migration/services/knowledge_service.dart'
    as migration;
import 'package:rvnow/shared/services/connectivity_service.dart';
import 'package:rvnow/shared/services/theme_service.dart';
import '../services/notification_service.dart';
import '../services/translation_service.dart';
import '../widgets/layouts/authenticated_layout.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final packageInfo = await PackageInfo.fromPlatform();
  getIt.registerSingleton<PackageInfo>(packageInfo);

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin());

  getIt.registerSingleton<NotificationService>(
      NotificationService(getIt<FlutterLocalNotificationsPlugin>()));

  getIt.registerSingleton<ConnectivityService>(
      ConnectivityService(Connectivity()));

  getIt.registerSingleton<ThemeService>(ThemeService());

  getIt.registerSingleton<TranslationService>(TranslationService());

  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<ProfileService>(ProfileService());
  getIt.registerSingleton<JwtService>(JwtService(getIt<SharedPreferences>()));
  getIt.registerSingleton<TrackService>(TrackService());
  getIt.registerSingleton<SubjectService>(SubjectService());
  getIt.registerSingleton<KnowledgeService>(KnowledgeService());
  getIt.registerSingleton<KnowledgeTypeService>(KnowledgeTypeService());
  getIt.registerSingleton<KnowledgeTopicService>(KnowledgeTopicService());
  getIt.registerSingleton<LearningService>(LearningService());
  getIt.registerSingleton<LearningListService>(LearningListService());
  getIt.registerSingleton<LearnAndReviewService>(LearnAndReviewService());
  getIt.registerSingleton<creating.KnowledgeService>(
      creating.KnowledgeService());
  getIt.registerSingleton<PublicationRequestService>(
      PublicationRequestService());
  getIt.registerSingleton<migration.KnowledgeService>(
      migration.KnowledgeService());
  getIt.registerSingleton<migration.KnowledgeTopicService>(
      migration.KnowledgeTopicService());

  getIt.registerSingleton<ValueNotifier<AuthenticatedLayoutSettings>>(
      ValueNotifier<AuthenticatedLayoutSettings>(
          const AuthenticatedLayoutSettings()));
  getIt.registerSingleton<AuthenticatedLayout>(AuthenticatedLayout(
      layoutSettings: getIt<ValueNotifier<AuthenticatedLayoutSettings>>()));
}
