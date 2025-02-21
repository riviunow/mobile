import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/exploring/track/screens/home_screen.dart';
import 'package:rvnow/shared/constants/error_message.dart';
import '../bloc/auth_bloc.dart';
import '../models/confirm_registration.dart';
import '../models/resend_code.dart';
import 'login_screen.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String email;
  final DateTime? confirmationCodeExpiryTime;

  static route(String email, {DateTime? confirmationCodeExpiryTime}) {
    return MaterialPageRoute(
        builder: (_) => ConfirmEmailScreen(
              email: email,
              confirmationCodeExpiryTime: confirmationCodeExpiryTime,
            ));
  }

  const ConfirmEmailScreen(
      {super.key, required this.email, this.confirmationCodeExpiryTime});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();
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
          if (state is AuthVerifyEmailSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(context, HomeScreen.route());
          } else if (state is AuthError &&
              (state.screen == AuthScreen.verifyEmail ||
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
              SnackBar(
                  content: Text(
                'confirmation_code_resent'.tr(),
                style: const TextStyle(color: Colors.black),
              )),
            );
          }
        },
        builder: (context, state) {
          Map<String, List<String>> fieldErrors = {};
          if (state is AuthLoading &&
              (state.screen == AuthScreen.verifyEmail ||
                  state.screen == AuthScreen.resendCode)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError &&
              (state.screen == AuthScreen.verifyEmail ||
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
                    errorText: fieldErrors['Email']?.join('\n'),
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
                    errorText: fieldErrors['ConfirmationCode']?.join('\n'),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _confirmEmail(context);
                  },
                ),
                const SizedBox(height: 20),
                if (confirmationCodeExpiryTime != null &&
                    timeLeft > Duration.zero)
                  Text(
                      '${'confirmation_code_sent_noti'.tr()}${timeLeft.inMinutes}m${timeLeft.inSeconds % 60}s'),
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
                    _confirmEmail(context);
                  },
                  child: Text('confirm_email'.tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmEmail(BuildContext context) {
    final email = emailController.text;
    final confirmationCode = codeController.text;
    final confirmRequest = ConfirmRegistrationEmailRequest(
        email: email, confirmationCode: confirmationCode);
    context.read<AuthBloc>().add(ConfirmEmailRequested(confirmRequest));
  }
}
