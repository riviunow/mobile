import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/services/jwt_service.dart';
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
