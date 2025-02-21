import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/auth/screens/confirm_email_screen.dart';
import 'package:rvnow/features/auth/screens/forgot_password_screen.dart';
import 'package:rvnow/features/auth/screens/register_screen.dart';
import 'package:rvnow/features/exploring/track/screens/home_screen.dart';
import 'package:rvnow/shared/constants/error_message.dart';
import 'package:rvnow/shared/widgets/layouts/unauthenticated_layout.dart';
import 'package:rvnow/shared/widgets/spaced_divider.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _emailFocusNode.requestFocus();
  }

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
                  context, ConfirmEmailScreen.route(_emailController.text));
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
                TextField(
                  focusNode: _emailFocusNode,
                  controller: _emailController,
                  onTapOutside: (_) {
                    if (_emailFocusNode.hasFocus) _emailFocusNode.unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: fieldErrors['Email']?.join('\n'),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    _passwordFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  onTapOutside: (_) {
                    if (_passwordFocusNode.hasFocus)
                      _passwordFocusNode.unfocus();
                  },
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Expanded(child: SpacedDivider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('or'.tr()),
                    ),
                    const Expanded(child: SpacedDivider()),
                  ],
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, UnauthenticatedLayout.route());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('explore_app'.tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _login(BuildContext context) {
    final email = _emailController.text;
    final password = _passwordController.text;
    final loginRequest = LoginRequest(email: email, password: password);
    context.read<AuthBloc>().add(LoginRequested(loginRequest));
  }
}
