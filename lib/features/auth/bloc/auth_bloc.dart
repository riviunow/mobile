import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/features/profile/bloc/profile_bloc.dart';
import '../models/confirm_registration.dart';
import '../models/login.dart';
import '../models/register.dart';
import '../models/confirm_reset_password.dart';
import '../models/forgot_password.dart';
import '../models/resend_code.dart';
import '../services/auth_service.dart';
import '../services/jwt_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final JwtService jwtService;
  final ProfileBloc profileBloc;

  AuthBloc(
    this.authService,
    this.jwtService,
    this.profileBloc,
  ) : super(AuthInitial()) {
    on<AppStarted>((event, emit) {
      profileBloc.add(LoadProfile());
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading(AuthScreen.login));
      var response = await authService.login(event.request);
      await response.on(
          onFailure: (errors, fieldErrors) =>
              emit(AuthError(errors, fieldErrors, AuthScreen.login)),
          onSuccess: (data) {
            jwtService.setAccessToken(data.tokenPair.accessToken);
            jwtService.setRefreshToken(data.tokenPair.refreshToken);
            profileBloc.add(LoadProfile(user: data.user));
            emit(AuthLoginSuccess(data));
          });
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading(AuthScreen.logout));
      var response = await authService.logout();
      await response.on(
          onFailure: (errors, fieldErrors) =>
              emit(AuthError(errors, fieldErrors, AuthScreen.logout)),
          onSuccess: (data) {
            emit(AuthLogoutSuccess(data));
          });
      await jwtService.removeAccessToken();
      await jwtService.removeRefreshToken();
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading(AuthScreen.register));
      var response = await authService.register(event.request);
      await response.on(
          onFailure: (errors, fieldErrors) =>
              emit(AuthError(errors, fieldErrors, AuthScreen.register)),
          onSuccess: (data) => emit(AuthRegisterSuccess(data)));
    });

    on<ConfirmEmailRequested>((event, emit) async {
      emit(AuthLoading(AuthScreen.verifyEmail));
      var response = await authService.confirmRegistrationEmail(event.request);
      await response.on(
          onFailure: (errors, fieldErrors) =>
              emit(AuthError(errors, fieldErrors, AuthScreen.verifyEmail)),
          onSuccess: (data) {
            jwtService.setAccessToken(data.tokenPair.accessToken);
            jwtService.setRefreshToken(data.tokenPair.refreshToken);
            profileBloc.add(LoadProfile(user: data.user));
            emit(AuthVerifyEmailSuccess(data));
          });
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading(AuthScreen.sendResetCode));
      var response = await authService.forgotPassword(event.request);
      await response.on(
          onFailure: (errors, fieldErrors) =>
              emit(AuthError(errors, fieldErrors, AuthScreen.sendResetCode)),
          onSuccess: (data) => emit(AuthSendResetCodeSuccess(data)));
    });

    on<ResendCodeRequested>((event, emit) async {
      emit(AuthLoading(AuthScreen.resendCode));
      var response = await authService.resendCode(event.request);
      await response.on(
          onFailure: (errors, fieldErrors) =>
              emit(AuthError(errors, fieldErrors, AuthScreen.resendCode)),
          onSuccess: (data) => emit(AuthResendCodeSuccess(data)));
    });

    on<ConfirmPasswordResetRequested>((event, emit) async {
      emit(AuthLoading(AuthScreen.verifyPasswordReset));
      var response =
          await authService.confirmForgotPasswordEmail(event.request);
      await response.on(
          onFailure: (errors, fieldErrors) => emit(
              AuthError(errors, fieldErrors, AuthScreen.verifyPasswordReset)),
          onSuccess: (data) {
            jwtService.setAccessToken(data.tokenPair.accessToken);
            jwtService.setRefreshToken(data.tokenPair.refreshToken);
            profileBloc.add(LoadProfile(user: data.user));
            emit(AuthVerifyPasswordResetSuccess(data));
          });
    });
  }
}
