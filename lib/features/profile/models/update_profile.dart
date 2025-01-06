import 'package:image_picker/image_picker.dart';

class UpdateProfileRequest {
  final String userName;
  final XFile? photo;

  UpdateProfileRequest({required this.userName, required this.photo});

  Map<String, String> toJson() {
    return {
      'userName': userName,
    };
  }

  XFile? get image => photo;
  String get imageFieldName => 'photo';
}
