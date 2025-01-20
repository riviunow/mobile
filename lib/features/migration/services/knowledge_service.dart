import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

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
