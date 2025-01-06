class AddRemoveKnowledgesRequest {
  final String learningListId;
  final List<String> knowledgeIds;
  final bool isAdd;

  AddRemoveKnowledgesRequest({
    required this.learningListId,
    required this.knowledgeIds,
    required this.isAdd,
  });

  Map<String, dynamic> toJson() {
    return {
      'LearningListId': learningListId,
      'KnowledgeIds': knowledgeIds,
      'IsAdd': isAdd,
    };
  }
}
