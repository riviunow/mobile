import 'package:udetxen/features/exploring/knowledge/models/knowledge_type.dart';
import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

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
