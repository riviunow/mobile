class ConfirmResetPasswordRequest {
  final String email;
  final String confirmationCode;
  final String password;
  final String confirmationPassword;

  ConfirmResetPasswordRequest({
    required this.email,
    required this.confirmationCode,
    required this.password,
    required this.confirmationPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'confirmationCode': confirmationCode,
      'password': password,
      'confirmationPassword': confirmationPassword,
    };
  }
}
