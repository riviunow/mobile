import 'package:rvnow/features/auth/models/confirm_registration.dart';
import 'package:rvnow/features/auth/models/confirm_reset_password.dart';
import 'package:rvnow/features/auth/models/forgot_password.dart';
import 'package:rvnow/features/auth/models/login.dart';
import 'package:rvnow/features/auth/models/register.dart';
import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

import '../models/resend_code.dart';

class AuthService extends ApiService {
  ApiResponse<LoginResponse> login(LoginRequest request) {
    return post<LoginResponse>(
        HttpRoute.login, LoginResponse.fromJson, request.toJson());
  }

  ApiResponse<User> register(RegisterRequest request) {
    return post<User>(HttpRoute.register, User.fromJson, request.toJson());
  }

  ApiResponse<LoginResponse> confirmRegistrationEmail(
      ConfirmRegistrationEmailRequest request) {
    return post<LoginResponse>(HttpRoute.confirmRegistrationEmail,
        LoginResponse.fromJson, request.toJson());
  }

  ApiResponse<User> forgotPassword(ForgotPasswordRequest request) {
    return post<User>(
        HttpRoute.forgotPassword, User.fromJson, request.toJson());
  }

  ApiResponse<User> resendCode(ResendCodeRequest request) {
    return post<User>(HttpRoute.resendCode, User.fromJson, request.toJson());
  }

  ApiResponse<LoginResponse> confirmForgotPasswordEmail(
      ConfirmResetPasswordRequest request) {
    return post<LoginResponse>(HttpRoute.confirmPasswordResettingEmail,
        LoginResponse.fromJson, request.toJson());
  }

  ApiResponse<User> logout() {
    return post<User>(HttpRoute.logout, User.fromJson, null);
  }
}
