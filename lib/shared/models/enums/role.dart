import 'package:easy_localization/easy_localization.dart';

enum Role {
  admin,
  user,
}

extension RoleExtension on Role {
  static Role fromJson(String json) {
    switch (json) {
      case 'Admin':
        return Role.admin;
      case 'User':
        return Role.user;
      default:
        throw ArgumentError('Unknown role: $json');
    }
  }

  String toJson() {
    switch (this) {
      case Role.admin:
        return 'Admin';
      case Role.user:
        return 'User';
    }
  }

  String toStr() {
    switch (this) {
      case Role.admin:
        return 'role.admin'.tr();
      case Role.user:
        return 'role.user'.tr();
    }
  }
}
