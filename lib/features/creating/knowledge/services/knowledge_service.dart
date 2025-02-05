import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

import '../models/get_created.dart';
import '../models/create.dart';
import '../models/update.dart';

class KnowledgeService extends ApiService {
  ApiResponse<Page<Knowledge>> getCreatedKnowledges(
      GetCreatedKnowledgesRequest request) {
    return postPage<Knowledge>(
      HttpRoute.getCreatedKnowledges,
      Knowledge.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<Knowledge> createKnowledge(CreateKnowledgeRequest request) {
    return postMultipart<Knowledge>(
      HttpRoute.createKnowledge,
      Knowledge.fromJson,
      request.toJson(),
      request.files,
    );
  }

  ApiResponse<Knowledge> updateKnowledge(UpdateKnowledgeRequest request) {
    return post<Knowledge>(
      HttpRoute.updateKnowledge,
      Knowledge.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<Knowledge> deleteKnowledge(String id) {
    return delete<Knowledge>(
        HttpRoute.deleteKnowledge(id), Knowledge.fromJson, null);
  }
}
