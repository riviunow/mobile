import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

class SubjectService extends ApiService {
  ApiResponse<Subject> getSubjectById(String id) {
    return get<Subject>(
        HttpRoute.getSubjectById(id), (item) => Subject.fromJson(item));
  }
}
