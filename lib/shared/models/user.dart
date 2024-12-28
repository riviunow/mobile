part of 'index.dart';

class User extends SingleIdEntity {
  final String userName;
  final String email;
  final String? photoUrl;
  final Role role;
  final Authentication? authentication;
  final List<LearningList> learningLists;
  final DateTime? confirmationCodeExpiryTime;

  User({
    required super.id,
    required super.createdAt,
    required this.userName,
    required this.email,
    this.photoUrl,
    this.role = Role.user,
    this.authentication,
    this.learningLists = const [],
    this.confirmationCodeExpiryTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      userName: json['userName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      role: RoleExtension.fromJson(json['role']),
      authentication: json['authentication'] != null
          ? Authentication.fromJson(json['authentication'])
          : null,
      learningLists: (json['learningLists'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => LearningList.fromJson(item))
          .toList(),
      confirmationCodeExpiryTime: json['confirmationCodeExpiryTime'] != null
          ? DateTime.parse(json['confirmationCodeExpiryTime'])
          : null,
    );
  }

  User copyWith({
    String? id,
    DateTime? createdAt,
    String? userName,
    String? email,
    String? photoUrl,
    Role? role,
    Authentication? authentication,
    List<LearningList>? learningLists,
    DateTime? confirmationCodeExpiryTime,
  }) {
    return User(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      authentication: authentication ?? this.authentication,
      learningLists: learningLists ?? this.learningLists,
      confirmationCodeExpiryTime:
          confirmationCodeExpiryTime ?? this.confirmationCodeExpiryTime,
    );
  }
}
