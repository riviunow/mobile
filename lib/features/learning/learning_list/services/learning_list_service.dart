import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

class LearningListService extends ApiService {
  ApiResponse<List<LearningList>> getLearningLists() {
    return getList(
        HttpRoute.getAllLearningLists, (item) => LearningList.fromJson(item));
  }
}
