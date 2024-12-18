class ConfirmRegistrationEmailRequest {
  final String email;
  final String confirmationCode;

  ConfirmRegistrationEmailRequest({
    required this.email,
    required this.confirmationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'confirmationCode': confirmationCode,
    };
  }
}
