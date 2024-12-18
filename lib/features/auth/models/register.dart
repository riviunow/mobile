class RegisterRequest {
  final String email;
  final String password;
  final String confirmationPassword;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmationPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirmationPassword': confirmationPassword,
    };
  }
}
