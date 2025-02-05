import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

import '../models/update_profile.dart';

class ProfileService extends ApiService {
  ApiResponse<User> getUser() {
    return get<User>(HttpRoute.getProfile, User.fromJson);
  }

  ApiResponse<User> updateProfile(UpdateProfileRequest request) {
    return postMultipart<User>(
        HttpRoute.updateProfile,
        User.fromJson,
        request.toJson(),
        request.image != null
            ? [(request.image!, request.imageFieldName)]
            : []);
  }
}
