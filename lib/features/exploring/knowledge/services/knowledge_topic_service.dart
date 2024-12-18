import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

import '../models/knowledge_topic.dart';

class KnowledgeTopicService extends ApiService {
  ApiResponse<List<KnowledgeTopic>> getKnowledgeTopics(
      KnowledgeTopicsRequest request) {
    return postList<KnowledgeTopic>(
      HttpRoute.getKnowledgeTopics,
      (item) => KnowledgeTopic.fromJson(item),
      request.toJson(),
    );
  }
}
