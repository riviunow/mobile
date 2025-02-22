import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rvnow/features/auth/bloc/auth_bloc.dart';
import 'package:rvnow/features/auth/screens/login_screen.dart';
import 'package:rvnow/features/auth/screens/register_screen.dart';
import 'package:rvnow/features/profile/bloc/profile_bloc.dart';
import 'package:rvnow/features/profile/screens/update_profile_screen.dart';
import 'package:rvnow/shared/config/service_locator.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/constants/urls.dart';
import 'package:rvnow/shared/services/theme_service.dart';
import 'package:rvnow/shared/widgets/layouts/authenticated_layout.dart';
import 'package:rvnow/shared/widgets/loader.dart';

import 'language_setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => getInstance(),
    );
  }

  static Widget getInstance() {
    getIt<ValueNotifier<AuthenticatedLayoutSettings>>().value =
        getIt<ValueNotifier<AuthenticatedLayoutSettings>>()
            .value
            .copyWith(initialIndex: 3);
    return getIt<AuthenticatedLayout>();
  }

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    var bloc = context.read<ProfileBloc>();
    if (bloc.state is! ProfileLoaded && bloc.state is! UnauthenticatedProfile) {
      bloc.add(LoadProfile());
    }
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('delete_account'.tr()),
          content: Text('delete_account_confirmation'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('delete'.tr()),
              onPressed: () {
                context.read<ProfileBloc>().add(DeleteAccount());
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(context, LoginScreen.route());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var packageInfo = getIt<PackageInfo>();
    var appName = packageInfo.appName;
    var version = packageInfo.version;

    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: Loading());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            final themeService = Provider.of<ThemeService>(context);
            final isDark = themeService.isDarkMode;
            final toggleTheme = themeService.toggleThemeMode;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user.photoUrl != null)
                          Center(
                            child: CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(
                                  "${Urls.mediaUrl}/${user.photoUrl!}"),
                            ),
                          )
                        else
                          const Center(
                            child: CircleAvatar(
                              radius: 100,
                              child: Icon(Icons.person, size: 100),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 24),
                            const SizedBox(width: 8),
                            Text(user.userName,
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 24),
                            const SizedBox(width: 8),
                            Text(user.email,
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text('update_profile'.tr()),
                    onTap: () =>
                        Navigator.push(context, UpdateProfileScreen.route()),
                  ),
                  ListTile(
                    leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                    title:
                        Text(isDark ? 'switch_light'.tr() : 'switch_dark'.tr()),
                    onTap: toggleTheme,
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text("language_settings".tr()),
                    onTap: () =>
                        Navigator.push(context, LanguageSettingsScreen.route()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text('logout'.tr()),
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.push(context, LoginScreen.route());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: AppColors.error),
                    title: Text('delete_account'.tr(),
                        style: const TextStyle(color: AppColors.error)),
                    onTap: () => _confirmDeleteAccount(context),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '$appName v$version',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is UnauthenticatedProfile) {
            final themeService = Provider.of<ThemeService>(context);
            final isDark = themeService.isDarkMode;
            final toggleTheme = themeService.toggleThemeMode;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                          context, LoginScreen.route()),
                      child: Text('login'.tr()),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                          context, RegisterScreen.route()),
                      child: Text('register'.tr()),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  title:
                      Text(isDark ? 'switch_light'.tr() : 'switch_dark'.tr()),
                  onTap: toggleTheme,
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text("language_settings".tr()),
                  onTap: () =>
                      Navigator.push(context, LanguageSettingsScreen.route()),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '$appName v$version',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.messages.join('\n')));
          } else {
            return Center(child: Text('no_data_available'.tr()));
          }
        },
      ),
    );
  }
}
