import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/auth/screens/confirm_email_screen.dart';
import 'package:udetxen/features/auth/screens/forgot_password_screen.dart';
import 'package:udetxen/features/auth/screens/register_screen.dart';
import 'package:udetxen/features/exploring/track/screens/home_screen.dart';
import 'package:udetxen/shared/constants/error_message.dart';
import '../bloc/auth_bloc.dart';
import '../models/login.dart';

class LoginScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (_) => const LoginScreen());
  }

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(context, HomeScreen.route());
          } else if (state is AuthError &&
              state.screen == AuthScreen.login &&
              state.messages.isNotEmpty) {
            if (state.messages.isNotEmpty &&
                state.messages.contains(
                    ErrorMessage.emailNotConfirmed.userFriendlyMessage)) {
              Navigator.push(
                  context, ConfirmEmailScreen.route(emailController.text));
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.messages.join(', '))),
            );
          }
        },
        builder: (context, state) {
          Map<String, List<String>> fieldErrors = {};
          if (state is AuthLoading && state.screen == AuthScreen.login) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError && state.screen == AuthScreen.login) {
            fieldErrors = state.fieldErrors;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Focus(
                  focusNode: emailFocusNode,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: fieldErrors['Email']?.join('\n'),
                    ),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Focus(
                  focusNode: passwordFocusNode,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: fieldErrors['Password']?.join('\n'),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      _login(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  child: Text('login'.tr()),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () =>
                      Navigator.push(context, RegisterScreen.route()),
                  child: Text('register'.tr()),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.push(context, ForgotPasswordScreen.route()),
                  child: Text('forgot_password'.tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _login(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;
    final loginRequest = LoginRequest(email: email, password: password);
    context.read<AuthBloc>().add(LoginRequested(loginRequest));
  }
}
