import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/auth/screens/login_screen.dart';
import 'package:udetxen/features/exploring/track/screens/home_screen.dart';
import 'package:udetxen/features/profile/bloc/profile_bloc.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pushReplacement(context, HomeScreen.route());
        } else if (state is ProfileError) {
          Navigator.pushReplacement(context, LoginScreen.route());
        }
      },
      child: const Center(child: Loading()),
    );
  }
}
