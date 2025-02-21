import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/auth/screens/confirm_email_screen.dart';
import 'package:rvnow/shared/constants/error_message.dart';
import 'package:rvnow/shared/widgets/layouts/unauthenticated_layout.dart';
import 'package:rvnow/shared/widgets/spaced_divider.dart';
import '../bloc/auth_bloc.dart';
import '../models/register.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (_) => const RegisterScreen());
  }

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmationPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmationPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmationPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            Navigator.push(
                context,
                ConfirmEmailScreen.route(state.user.email,
                    confirmationCodeExpiryTime:
                        state.user.confirmationCodeExpiryTime));
          } else if (state is AuthError &&
              state.screen == AuthScreen.register) {
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
          if (state is AuthLoading && state.screen == AuthScreen.register) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError &&
              state.screen == AuthScreen.register) {
            fieldErrors = state.fieldErrors;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onTapOutside: (_) {
                    if (emailFocusNode.hasFocus) emailFocusNode.unfocus();
                  },
                  focusNode: emailFocusNode,
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
                const SizedBox(height: 10),
                TextField(
                  onTapOutside: (_) {
                    if (passwordFocusNode.hasFocus) passwordFocusNode.unfocus();
                  },
                  focusNode: passwordFocusNode,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: fieldErrors['Password']?.join('\n'),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(confirmationPasswordFocusNode);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  onTapOutside: (_) {
                    if (confirmationPasswordFocusNode.hasFocus)
                      confirmationPasswordFocusNode.unfocus();
                  },
                  focusNode: confirmationPasswordFocusNode,
                  controller: confirmationPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: fieldErrors['ConfirmationPassword']?.join('\n'),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _register(context);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _register(context);
                  },
                  child: Text('register'.tr()),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(context, LoginScreen.route());
                    }
                  },
                  child: Text('login'.tr()),
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

  void _register(BuildContext context) {
    final confirmationPassword = confirmationPasswordController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final registerRequest = RegisterRequest(
        confirmationPassword: confirmationPassword,
        email: email,
        password: password);
    context.read<AuthBloc>().add(RegisterRequested(registerRequest));
  }
}
