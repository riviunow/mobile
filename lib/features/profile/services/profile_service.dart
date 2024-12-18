import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

import '../models/update_profile.dart';

class ProfileService extends ApiService {
  ApiResponse<User> getUser() {
    return get<User>(HttpRoute.getProfile, User.fromJson);
  }

  ApiResponse<User> updateProfile(UpdateProfileRequest request) {
    return postMultipart<User>(HttpRoute.updateProfile, User.fromJson,
        request.toJson(), request.image, request.imageFieldName);
  }
}
