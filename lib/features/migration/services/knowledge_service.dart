import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

import '../models/migrate.dart';

class KnowledgeService extends ApiService {
  ApiResponse<List<Learning>> migrateKnowledges(MigrateRequest request) {
    return postList<Learning>(
      HttpRoute.migrate,
      (e) => Learning.fromJson(e),
      request.toJson(),
    );
  }
}
