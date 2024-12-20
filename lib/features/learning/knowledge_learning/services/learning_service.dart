import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

import '../models/current_user_learning.dart';

class LearningService extends ApiService {
  ApiResponse<Page<Learning>> getLearnings(
      GetCurrentUserLearningRequest request) {
    return postPage(HttpRoute.getCurrentUserLearnings,
        (item) => Learning.fromJson(item), request.toJson());
  }

  ApiResponse<List<Learning>> getUnlistedLearnings() {
    return getList(
        HttpRoute.getUnlistedLearnings, (item) => Learning.fromJson(item));
  }
}
