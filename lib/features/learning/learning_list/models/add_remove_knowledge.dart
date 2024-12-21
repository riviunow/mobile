class AddRemoveKnowledgeRequest {
  final String learningListId;
  final String knowledgeId;

  AddRemoveKnowledgeRequest({
    required this.learningListId,
    required this.knowledgeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'LearningListId': learningListId,
      'KnowledgeId': knowledgeId,
    };
  }
}
