import 'package:udetxen/features/creating/publication_request/models/publish_knowledge.dart';
import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

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
