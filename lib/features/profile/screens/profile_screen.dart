import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:udetxen/features/auth/bloc/auth_bloc.dart';
import 'package:udetxen/features/auth/screens/login_screen.dart';
import 'package:udetxen/features/profile/bloc/profile_bloc.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:udetxen/shared/constants/urls.dart';
import 'package:udetxen/shared/services/theme_service.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class ProfileScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => getInstance(),
    );
  }

  static Widget getInstance() {
    final valueNotifier = getIt<ValueNotifier<(int, int)>>();
    valueNotifier.value = (3, valueNotifier.value.$2);
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
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
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
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user.photoUrl != null)
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  "${Urls.mediaUrl}/${user.photoUrl!}"),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text('Username: ${user.userName}',
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text('Email: ${user.email}',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                    title: Text(isDark
                        ? 'Switch to Light Mode'
                        : 'Switch to Dark Mode'),
                    onTap: toggleTheme,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.push(context, LoginScreen.route());
                    },
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.messages.join('\n')}'));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
