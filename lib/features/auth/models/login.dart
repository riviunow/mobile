import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final User user;
  final JWTPairResponse tokenPair;

  LoginResponse({required this.user, required this.tokenPair});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user']),
      tokenPair: JWTPairResponse.fromJson(json['tokenPair']),
    );
  }
}
