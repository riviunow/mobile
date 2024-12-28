class GetLearningToReviewRequest {
  final List<String> knowledgeIds;

  GetLearningToReviewRequest({required this.knowledgeIds});

  Map<String, dynamic> toJson() {
    return {
      'KnowledgeIds': knowledgeIds,
    };
  }
}
