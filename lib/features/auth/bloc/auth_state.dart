part of 'auth_bloc.dart';

enum AuthScreen {
  login,
  register,
  verifyEmail,
  logout,
  sendResetCode,
  resendCode,
  verifyPasswordReset,
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final AuthScreen screen;

  AuthLoading(this.screen);
}

class AuthError extends AuthState {
  final List<String> messages;
  final Map<String, List<String>> fieldErrors;
  final AuthScreen screen;

  AuthError(this.messages, this.fieldErrors, this.screen);
}

class AuthLoginSuccess extends AuthState {
  final LoginResponse response;

  AuthLoginSuccess(this.response);
}

class AuthRegisterSuccess extends AuthState {
  final User user;

  AuthRegisterSuccess(this.user);
}

class AuthVerifyEmailSuccess extends AuthState {
  final LoginResponse response;

  AuthVerifyEmailSuccess(this.response);
}

class AuthLogoutSuccess extends AuthState {
  final User user;

  AuthLogoutSuccess(this.user);
}

class AuthSendResetCodeSuccess extends AuthState {
  final User user;

  AuthSendResetCodeSuccess(this.user);
}

class AuthResendCodeSuccess extends AuthState {
  final User user;

  AuthResendCodeSuccess(this.user);
}

class AuthVerifyPasswordResetSuccess extends AuthState {
  final LoginResponse response;

  AuthVerifyPasswordResetSuccess(this.response);
}
