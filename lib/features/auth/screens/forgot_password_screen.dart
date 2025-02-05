import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/auth/screens/confirm_email_screen.dart';
import 'package:rvnow/features/auth/screens/confirm_password_reset.dart';
import 'package:rvnow/shared/constants/error_message.dart';
import '../bloc/auth_bloc.dart';
import '../models/forgot_password.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
  }

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSendResetCodeSuccess) {
            Navigator.push(
                context,
                ConfirmPasswordResetScreen.route(emailController.text,
                    confirmationCodeExpiryTime:
                        state.user.confirmationCodeExpiryTime));
          } else if (state is AuthError &&
              state.screen == AuthScreen.sendResetCode) {
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
          if (state is AuthLoading &&
              state.screen == AuthScreen.sendResetCode) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError &&
              state.screen == AuthScreen.sendResetCode) {
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
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      _sendResetCode(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _sendResetCode(context);
                  },
                  child: Text('send_reset_code'.tr()),
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
              ],
            ),
          );
        },
      ),
    );
  }

  void _sendResetCode(BuildContext context) {
    final email = emailController.text;
    final forgotPasswordRequest = ForgotPasswordRequest(email: email);
    context
        .read<AuthBloc>()
        .add(ForgotPasswordRequested(forgotPasswordRequest));
  }
}
