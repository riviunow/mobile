import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'features/creating/publication_request/services/publication_request_service.dart';
import 'features/exploring/knowledge/blocs/knowledge_detail_bloc.dart';
import 'features/learning/knowledge_learning/blocs/unlisted_learnings_bloc.dart';
import 'features/learning/learning_list/blocs/add_remove_knowledges_bloc.dart';
import 'features/learning/learning_list/blocs/create_learning_list_bloc.dart';
import 'features/learning/learning_list/blocs/get_learning_list_by_id_bloc.dart';
import 'features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import 'features/learning/learning_list/blocs/remove_learning_list_bloc.dart';
import 'features/learning/learning_list/blocs/update_learning_list_bloc.dart';
import 'features/migration/blocs/get_for_migration_bloc.dart';
import 'features/migration/blocs/migrate_bloc.dart';
import 'shared/services/translation_service.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/services/jwt_service.dart';
import 'features/creating/knowledge/services/knowledge_service.dart'
    as creating;
import 'features/creating/knowledge/blocs/create_knowledge_bloc.dart';
import 'features/creating/knowledge/blocs/created_knowledges_bloc.dart';
import 'features/creating/knowledge/blocs/delete_knowledge_bloc.dart';
import 'features/creating/knowledge/blocs/update_knowledge_bloc.dart';
import 'features/creating/publication_request/blocs/delete_publication_request_bloc.dart';
import 'features/creating/publication_request/blocs/get_publication_requests_bloc.dart';
import 'features/creating/publication_request/blocs/publish_knowledge_bloc.dart';
import 'features/exploring/knowledge/blocs/search_knowledges_bloc.dart';
import 'features/exploring/knowledge/blocs/knowledge_topic_bloc.dart';
import 'features/exploring/knowledge/blocs/knowledge_type_bloc.dart';
import 'features/exploring/knowledge/services/knowledge_service.dart';
import 'features/exploring/knowledge/services/knowledge_topic_service.dart';
import 'features/exploring/knowledge/services/knowledge_type_service.dart';
import 'features/exploring/subject/blocs/subject_bloc.dart';
import 'features/exploring/subject/services/subject_service.dart';
import 'features/exploring/track/blocs/list_tracks_bloc.dart';
import 'features/exploring/track/blocs/track_bloc.dart';
import 'features/exploring/track/services/track_service.dart';
import 'features/learning/knowledge_learning/blocs/current_user_learnings_bloc.dart';
import 'features/learning/knowledge_learning/services/learning_service.dart';
import 'features/learning/learn_and_review/blocs/game_bloc.dart';
import 'features/learning/learn_and_review/blocs/get_to_learn_bloc.dart';
import 'features/learning/learn_and_review/blocs/get_to_review_bloc.dart';
import 'features/learning/learn_and_review/services/learn_and_review_service.dart';
import 'features/learning/learning_list/services/learning_list_service.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/migration/services/knowledge_topic_service.dart' as migration;
import 'features/migration/services/knowledge_service.dart' as migration;
import 'shared/widgets/splash_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'features/profile/services/profile_service.dart';
import 'shared/config/theme/app_theme.dart';
import 'shared/config/initializer.dart';
import 'shared/config/service_locator.dart';
import 'shared/services/theme_service.dart';
import 'shared/services/connectivity_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await setupLocator();

  await initialize();

  const String env = String.fromEnvironment('ENV', defaultValue: 'development');
  await dotenv.load(fileName: ".env.$env");

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('vi')],
    path: 'assets/langs',
    fallbackLocale: const Locale('en'),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            return ProfileBloc(getIt<ProfileService>(), getIt<JwtService>());
          }),
          BlocProvider(
            create: (context) {
              return AuthBloc(
                getIt<AuthService>(),
                getIt<JwtService>(),
                BlocProvider.of<ProfileBloc>(context),
              );
            },
          ),
          BlocProvider(
            create: (context) => TrackBloc(getIt<TrackService>()),
          ),
          BlocProvider(
            create: (context) => ListTracksBloc(getIt<TrackService>()),
          ),
          BlocProvider(
            create: (context) => SubjectBloc(
                getIt<SubjectService>(), BlocProvider.of<TrackBloc>(context)),
          ),
          BlocProvider(
            create: (context) =>
                SearchKnowledgesBloc(getIt<KnowledgeService>()),
          ),
          BlocProvider(
            create: (context) => KnowledgeDetailBloc(getIt<KnowledgeService>()),
          ),
          BlocProvider(
            create: (context) =>
                CreatedKnowledgesBloc(getIt<creating.KnowledgeService>()),
          ),
          BlocProvider(
            create: (context) =>
                CreateKnowledgeBloc(getIt<creating.KnowledgeService>()),
          ),
          BlocProvider(
            create: (context) => UpdateKnowledgeBloc(
                getIt<creating.KnowledgeService>(),
                BlocProvider.of<CreatedKnowledgesBloc>(context)),
          ),
          BlocProvider(
            create: (context) => DeleteKnowledgeBloc(
                getIt<creating.KnowledgeService>(),
                BlocProvider.of<CreatedKnowledgesBloc>(context)),
          ),
          BlocProvider(
            create: (context) =>
                GetPublicationRequestsBloc(getIt<PublicationRequestService>()),
          ),
          BlocProvider(
            create: (context) => PublishKnowledgeBloc(
              getIt<PublicationRequestService>(),
              BlocProvider.of<CreatedKnowledgesBloc>(context),
              BlocProvider.of<GetPublicationRequestsBloc>(context),
            ),
          ),
          BlocProvider(
            create: (context) => DeletePublicationRequestBloc(
              getIt<PublicationRequestService>(),
              BlocProvider.of<CreatedKnowledgesBloc>(context),
              BlocProvider.of<GetPublicationRequestsBloc>(context),
            ),
          ),
          BlocProvider(
            create: (context) =>
                KnowledgeTypeBloc(getIt<KnowledgeTypeService>()),
          ),
          BlocProvider(
            create: (context) =>
                KnowledgeTopicBloc(getIt<KnowledgeTopicService>()),
          ),
          BlocProvider(
            create: (context) =>
                GetCurrentUserLearningsBloc(getIt<LearningService>()),
          ),
          BlocProvider(
            create: (context) =>
                UnlistedLearningsBloc(getIt<LearningService>()),
          ),
          BlocProvider(
            create: (context) =>
                GetLearningListsBloc(getIt<LearningListService>()),
          ),
          BlocProvider(
            create: (context) => GetLearningListByIdBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListsBloc>(context)),
          ),
          BlocProvider(
            create: (context) => CreateLearningListBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListsBloc>(context)),
          ),
          BlocProvider(
            create: (context) => UpdateLearningListBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListByIdBloc>(context)),
          ),
          BlocProvider(
            create: (context) => RemoveLearningListBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListsBloc>(context)),
          ),
          BlocProvider(
            create: (context) => AddRemoveKnowledgesBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListByIdBloc>(context),
                BlocProvider.of<UnlistedLearningsBloc>(context)),
          ),
          BlocProvider(
            create: (context) => GameBloc(
              getIt<LearnAndReviewService>(),
              BlocProvider.of<SubjectBloc>(context),
              BlocProvider.of<SearchKnowledgesBloc>(context),
              BlocProvider.of<GetCurrentUserLearningsBloc>(context),
              BlocProvider.of<UnlistedLearningsBloc>(context),
              BlocProvider.of<GetLearningListByIdBloc>(context),
              BlocProvider.of<GetLearningListsBloc>(context),
            ),
          ),
          BlocProvider(
            create: (context) => GetToLearnBloc(getIt<LearnAndReviewService>(),
                BlocProvider.of<GameBloc>(context)),
          ),
          BlocProvider(
            create: (context) => GetToReviewBloc(getIt<LearnAndReviewService>(),
                BlocProvider.of<GameBloc>(context)),
          ),
          BlocProvider(
            create: (context) =>
                GetForMigrationBloc(getIt<migration.KnowledgeTopicService>()),
          ),
          BlocProvider(
            create: (context) => MigrateBloc(
                getIt<migration.KnowledgeService>(),
                BlocProvider.of<GetForMigrationBloc>(context),
                BlocProvider.of<GetCurrentUserLearningsBloc>(context),
                BlocProvider.of<UnlistedLearningsBloc>(context),
                BlocProvider.of<GetLearningListByIdBloc>(context),
                BlocProvider.of<GetLearningListsBloc>(context)),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>(
              create: (_) => getIt<ThemeService>(),
            ),
            ChangeNotifierProvider<ConnectivityService>(
              create: (_) => getIt<ConnectivityService>(),
            ),
            ChangeNotifierProvider<TranslationService>(
              create: (_) => getIt<TranslationService>(),
            ),
          ],
          child: Consumer<ThemeService>(
            builder: (context, themeService, _) {
              var authBloc = BlocProvider.of<AuthBloc>(context);
              authBloc.add(AppStarted());
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: themeService.isDarkMode
                    ? AppTheme.darkTheme
                    : AppTheme.lightTheme,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: const SplashScreen(),
              );
            },
          ),
        ));
  }
}
