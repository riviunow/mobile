part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final LoginRequest request;

  LoginRequested(this.request);
}

class LogoutRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final RegisterRequest request;

  RegisterRequested(this.request);
}

class ConfirmEmailRequested extends AuthEvent {
  final ConfirmRegistrationEmailRequest request;

  ConfirmEmailRequested(this.request);
}

class ForgotPasswordRequested extends AuthEvent {
  final ForgotPasswordRequest request;

  ForgotPasswordRequested(this.request);
}

class ResendCodeRequested extends AuthEvent {
  final ResendCodeRequest request;

  ResendCodeRequested(this.request);
}

class ConfirmPasswordResetRequested extends AuthEvent {
  final ConfirmResetPasswordRequest request;

  ConfirmPasswordResetRequested(this.request);
}
