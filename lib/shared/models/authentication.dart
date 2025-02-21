part of 'index.dart';

class Authentication extends SingleIdEntity {
  final String hashedPassword;
  final String? refreshToken;
  final DateTime? refreshTokenExpiryTime;
  final String? confirmationCode;
  final DateTime? confirmationCodeExpiryTime;
  final bool isEmailConfirmed;
  final bool isActivated;
  final User? user;
  final String userId;

  Authentication({
    required super.id,
    required super.createdAt,
    required this.hashedPassword,
    this.refreshToken,
    this.refreshTokenExpiryTime,
    this.confirmationCode,
    this.confirmationCodeExpiryTime,
    required this.isEmailConfirmed,
    required this.isActivated,
    this.user,
    required this.userId,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      id: json['id'],
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      hashedPassword: json['hashedPassword'],
      refreshToken: json['refreshToken'],
      refreshTokenExpiryTime: json['refreshTokenExpiryTime'] != null
          ? parseUtcDateTime(json['refreshTokenExpiryTime'] as String)
          : null,
      confirmationCode: json['confirmationCode'],
      confirmationCodeExpiryTime: json['confirmationCodeExpiryTime'] != null
          ? parseUtcDateTime(json['confirmationCodeExpiryTime'] as String)
          : null,
      isEmailConfirmed: json['isEmailConfirmed'],
      isActivated: json['isActivated'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      userId: json['userId'],
    );
  }

  Authentication copyWith({
    String? id,
    DateTime? createdAt,
    String? hashedPassword,
    String? refreshToken,
    DateTime? refreshTokenExpiryTime,
    String? confirmationCode,
    DateTime? confirmationCodeExpiryTime,
    bool? isEmailConfirmed,
    bool? isActivated,
    User? user,
    String? userId,
  }) {
    return Authentication(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExpiryTime:
          refreshTokenExpiryTime ?? this.refreshTokenExpiryTime,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      confirmationCodeExpiryTime:
          confirmationCodeExpiryTime ?? this.confirmationCodeExpiryTime,
      isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
      isActivated: isActivated ?? this.isActivated,
      user: user ?? this.user,
      userId: userId ?? this.userId,
    );
  }
}
