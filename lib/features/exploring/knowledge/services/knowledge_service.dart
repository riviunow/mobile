import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

import '../models/search_knowledge.dart';

class KnowledgeService extends ApiService {
  ApiResponse<Page<Knowledge>> searchKnowledges(
      SearchKnowledgesRequest request) {
    return postPage<Knowledge>(
      HttpRoute.searchKnowledges,
      Knowledge.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<Knowledge> getKnowledge(String id) {
    return get<Knowledge>(
      HttpRoute.getDetailedKnowledgeByGuid(id),
      Knowledge.fromJson,
    );
  }
}
