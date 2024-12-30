import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:udetxen/features/auth/services/auth_service.dart';
import 'package:udetxen/features/auth/services/jwt_service.dart';
import 'package:udetxen/features/creating/knowledge/services/knowledge_service.dart'
    as creating;
import 'package:udetxen/features/exploring/knowledge/services/knowledge_service.dart';
import 'package:udetxen/features/exploring/knowledge/services/knowledge_topic_service.dart';
import 'package:udetxen/features/exploring/knowledge/services/knowledge_type_service.dart';
import 'package:udetxen/features/exploring/subject/services/subject_service.dart';
import 'package:udetxen/features/exploring/track/services/track_service.dart';
import 'package:udetxen/features/learning/knowledge_learning/services/learning_service.dart';
import 'package:udetxen/features/learning/learn_and_review/services/learn_and_review_service.dart';
import 'package:udetxen/features/learning/learning_list/services/learning_list_service.dart';
import 'package:udetxen/features/profile/services/profile_service.dart';
import 'package:udetxen/shared/services/connectivity_service.dart';
import 'package:udetxen/shared/services/theme_service.dart';
import '../services/notification_service.dart';
import '../widgets/layouts/authenticated_layout.dart';

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

  getIt.registerSingleton<ValueNotifier<AuthenticatedLayoutSettings>>(
      ValueNotifier<AuthenticatedLayoutSettings>(
          const AuthenticatedLayoutSettings()));
  getIt.registerSingleton<AuthenticatedLayout>(AuthenticatedLayout(
      layoutSettings: getIt<ValueNotifier<AuthenticatedLayoutSettings>>()));
}
