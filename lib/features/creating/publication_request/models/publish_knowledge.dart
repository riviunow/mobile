class PublishKnowledgeRequest {
  final String knowledgeId;

  PublishKnowledgeRequest({required this.knowledgeId});

  Map<String, dynamic> toJson() {
    return {
      'knowledgeId': knowledgeId,
    };
  }
}
