import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

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
