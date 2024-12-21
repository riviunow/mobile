import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:udetxen/features/exploring/knowledge/blocs/knowledge_detail_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/blocs/unlisted_learnings_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/add_remove_knowledge_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/create_learning_list_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_list_by_id_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/remove_learning_list_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/update_learning_list_bloc.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/services/jwt_service.dart';
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
import 'features/learning/learning_list/services/learning_list_service.dart';
import 'features/profile/bloc/profile_bloc.dart';
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

  await setupLocator();

  await initialize();

  runApp(const MainApp());
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
            create: (context) => SubjectBloc(getIt<SubjectService>()),
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
            create: (context) =>
                GetLearningListByIdBloc(getIt<LearningListService>()),
          ),
          BlocProvider(
            create: (context) => CreateLearningListBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListsBloc>(context)),
          ),
          BlocProvider(
            create: (context) => UpdateLearningListBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListByIdBloc>(context),
                BlocProvider.of<GetLearningListsBloc>(context)),
          ),
          BlocProvider(
            create: (context) => RemoveLearningListBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListsBloc>(context)),
          ),
          BlocProvider(
            create: (context) => AddRemoveKnowledgeBloc(
                getIt<LearningListService>(),
                BlocProvider.of<GetLearningListByIdBloc>(context)),
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
          ],
          child: Consumer<ThemeService>(
            builder: (context, themeService, _) {
              var authBloc = BlocProvider.of<AuthBloc>(context);
              authBloc.add(AppStarted());
              return MaterialApp(
                navigatorKey: navigatorKey,
                theme: themeService.isDarkMode
                    ? AppTheme.darkTheme
                    : AppTheme.lightTheme,
                home: const SplashScreen(),
              );
            },
          ),
        ));
  }
}
