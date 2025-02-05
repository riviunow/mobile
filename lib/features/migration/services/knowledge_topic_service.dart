import 'package:rvnow/features/migration/models/get_for_migration.dart';
import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

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
