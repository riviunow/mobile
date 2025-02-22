import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/auth/screens/login_screen.dart';
import 'package:rvnow/features/exploring/track/screens/home_screen.dart';
import 'package:rvnow/features/profile/bloc/profile_bloc.dart';
import 'package:rvnow/shared/config/service_locator.dart';
import 'package:rvnow/shared/widgets/loader.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var packageInfo = getIt<PackageInfo>();
    var appName = packageInfo.appName;
    var version = packageInfo.version;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pushReplacement(context, HomeScreen.route());
        } else if (state is UnauthenticatedProfile) {
          Navigator.pushReplacement(context, LoginScreen.route());
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.jpg', height: 100),
                  const SizedBox(height: 20),
                  const Loading(),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Text(
                appName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Text(
                '${"version".tr()} v$version',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
