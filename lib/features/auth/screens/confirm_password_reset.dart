import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/auth/screens/login_screen.dart';
import 'package:rvnow/features/exploring/track/screens/home_screen.dart';
import 'package:rvnow/shared/constants/error_message.dart';
import '../bloc/auth_bloc.dart';
import '../models/confirm_reset_password.dart';
import '../models/resend_code.dart';

class ConfirmPasswordResetScreen extends StatefulWidget {
  final String email;
  final DateTime? confirmationCodeExpiryTime;

  static route(String email, {DateTime? confirmationCodeExpiryTime}) {
    return MaterialPageRoute(
        builder: (_) => ConfirmPasswordResetScreen(
              email: email,
              confirmationCodeExpiryTime: confirmationCodeExpiryTime,
            ));
  }

  const ConfirmPasswordResetScreen(
      {super.key, required this.email, this.confirmationCodeExpiryTime});

  @override
  State<ConfirmPasswordResetScreen> createState() =>
      _ConfirmPasswordResetScreenState();
}

class _ConfirmPasswordResetScreenState
    extends State<ConfirmPasswordResetScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  DateTime? confirmationCodeExpiryTime;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
    confirmationCodeExpiryTime = widget.confirmationCodeExpiryTime;
    codeFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyPasswordResetSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(context, HomeScreen.route());
          } else if (state is AuthError &&
              (state.screen == AuthScreen.verifyPasswordReset ||
                  state.screen == AuthScreen.resendCode)) {
            if (state.messages.isNotEmpty) {
              if (state.messages.contains(
                  ErrorMessage.emailAlreadyConfirmed.userFriendlyMessage)) {
                Navigator.pushReplacement(context, LoginScreen.route());
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.messages.join(', '))),
              );
            }
          } else if (state is AuthResendCodeSuccess) {
            setState(() {
              confirmationCodeExpiryTime =
                  state.user.confirmationCodeExpiryTime;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('confirmation_code_resent'.tr())),
            );
          }
        },
        builder: (context, state) {
          Map<String, List<String>> fieldErrors = {};
          if (state is AuthLoading &&
              (state.screen == AuthScreen.verifyPasswordReset ||
                  state.screen == AuthScreen.resendCode)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError &&
              (state.screen == AuthScreen.verifyPasswordReset ||
                  state.screen == AuthScreen.resendCode)) {
            fieldErrors = state.fieldErrors;
          }

          final timeLeft = confirmationCodeExpiryTime != null
              ? confirmationCodeExpiryTime!.difference(DateTime.now())
              : Duration.zero;

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
                    errorText: fieldErrors['Email']?.join(', '),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(codeFocusNode);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  onTapOutside: (_) {
                    if (codeFocusNode.hasFocus) codeFocusNode.unfocus();
                  },
                  focusNode: codeFocusNode,
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Confirmation Code',
                    errorText: fieldErrors['ConfirmationCode']?.join(', '),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(newPasswordFocusNode);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  onTapOutside: (_) {
                    if (newPasswordFocusNode.hasFocus)
                      newPasswordFocusNode.unfocus();
                  },
                  focusNode: newPasswordFocusNode,
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    errorText: fieldErrors['Password']?.join(', '),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(confirmPasswordFocusNode);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  onTapOutside: (_) {
                    if (confirmPasswordFocusNode.hasFocus)
                      confirmPasswordFocusNode.unfocus();
                  },
                  focusNode: confirmPasswordFocusNode,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: fieldErrors['ConfirmationPassword']?.join(', '),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _resetPassword(context);
                  },
                ),
                const SizedBox(height: 20),
                if (confirmationCodeExpiryTime != null &&
                    timeLeft > Duration.zero)
                  Text(
                      'Confirmation code has been sent to your email. It will expire in ${timeLeft.inMinutes} minutes and ${timeLeft.inSeconds % 60} seconds.'),
                if (confirmationCodeExpiryTime == null ||
                    timeLeft <= Duration.zero)
                  ElevatedButton(
                    onPressed: () {
                      final email = emailController.text;
                      final resendRequest = ResendCodeRequest(email: email);
                      context
                          .read<AuthBloc>()
                          .add(ResendCodeRequested(resendRequest));
                    },
                    child: Text('resend_code'.tr()),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _resetPassword(context);
                  },
                  child: Text('reset_password'.tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _resetPassword(BuildContext context) {
    final email = emailController.text;
    final confirmationCode = codeController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    final confirmResetPasswordRequest = ConfirmResetPasswordRequest(
      email: email,
      confirmationCode: confirmationCode,
      password: newPassword,
      confirmationPassword: confirmPassword,
    );
    context
        .read<AuthBloc>()
        .add(ConfirmPasswordResetRequested(confirmResetPasswordRequest));
  }
}
