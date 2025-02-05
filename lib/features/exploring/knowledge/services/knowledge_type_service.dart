import 'package:rvnow/features/exploring/knowledge/models/knowledge_type.dart';
import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

class KnowledgeTypeService extends ApiService {
  ApiResponse<List<KnowledgeType>> getKnowledgeTypes(
      KnowledgeTypesRequest request) {
    return postList<KnowledgeType>(
      HttpRoute.getKnowledgeTypes,
      (item) => KnowledgeType.fromJson(item),
      request.toJson(),
    );
  }
}
