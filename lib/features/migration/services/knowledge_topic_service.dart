import 'package:udetxen/features/migration/models/get_for_migration.dart';
import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

class KnowledgeTopicService extends ApiService {
  ApiResponse<List<KnowledgeTopic>> getKnowledgeTopicsForMigration(
      GetForMigrationRequest request) {
    return postList<KnowledgeTopic>(
      HttpRoute.getTopicsForMigration,
      (item) => KnowledgeTopic.fromJson(item),
      request.toJson(),
    );
  }
}
