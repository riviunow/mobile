class ReviewLearningRequest {
  final List<ReviewKnowledgeParams> groupedKnowledges;

  ReviewLearningRequest({required this.groupedKnowledges});

  Map<String, dynamic> toJson() {
    return {
      'GroupedKnowledges': groupedKnowledges,
    };
  }
}

class ReviewKnowledgeParams {
  final String knowledgeId;
  final String questionId;
  final String answer;

  final String interpretation;
  final String wordMatchAnswer;

  ReviewKnowledgeParams({
    required this.knowledgeId,
    required this.questionId,
    required this.answer,
    required this.interpretation,
    required this.wordMatchAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'KnowledgeId': knowledgeId,
      'QuestionId': questionId,
      'Answer': answer,
      'Interpretation': interpretation,
      'WordMatchAnswer': wordMatchAnswer,
    };
  }
}
