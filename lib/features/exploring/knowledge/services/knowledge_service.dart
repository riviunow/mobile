import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

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
}
