class GetKnowledgesToLearnRequest {
  final List<String> knowledgeIds;
  final String? newLearningListTitle;

  GetKnowledgesToLearnRequest(
      {required this.knowledgeIds, this.newLearningListTitle});

  Map<String, dynamic> toJson() {
    return {
      'KnowledgeIds': knowledgeIds,
      'NewLearningListTitle': newLearningListTitle,
    };
  }
}
