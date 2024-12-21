class CreateLearningListRequest {
  final String title;

  final List<String>? knowledgeIds;

  CreateLearningListRequest({
    required this.title,
    this.knowledgeIds,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'knowledgeIds': knowledgeIds,
    };
  }
}
