import 'package:rvnow/features/creating/publication_request/models/publish_knowledge.dart';
import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

import '../models/get_requests.dart';

class PublicationRequestService extends ApiService {
  ApiResponse<PublicationRequest> publishKnowledge(
      PublishKnowledgeRequest request) {
    return post<PublicationRequest>(
      HttpRoute.requestPublishKnowledge,
      PublicationRequest.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<PublicationRequest> deleteRequest(String publicationRequestId) {
    return delete<PublicationRequest>(
        HttpRoute.deletePublicationRequest(publicationRequestId),
        PublicationRequest.fromJson,
        null);
  }

  ApiResponse<Page<PublicationRequest>> getPublicationRequests(
      GetPublicationRequests request) {
    return postPage(HttpRoute.getPublicationRequests,
        PublicationRequest.fromJson, request.toJson());
  }
}
