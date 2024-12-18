class ResendCodeRequest {
  final String email;

  ResendCodeRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
