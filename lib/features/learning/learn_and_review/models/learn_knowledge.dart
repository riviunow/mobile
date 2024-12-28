class LearnKnowledgeRequest {
  final List<LearnKnowledgeParams> groupedKnowledges;

  LearnKnowledgeRequest({required this.groupedKnowledges});

  Map<String, dynamic> toJson() {
    return {
      'GroupedKnowledges': groupedKnowledges,
    };
  }
}

class LearnKnowledgeParams {
  final String knowledgeId;
  final String questionIdOne;
  final String answerOne;
  final String questionIdTwo;
  final String answerTwo;
  final String interpretation;
  final String wordMatchAnswer;

  LearnKnowledgeParams({
    required this.knowledgeId,
    required this.questionIdOne,
    required this.answerOne,
    required this.questionIdTwo,
    required this.answerTwo,
    required this.interpretation,
    required this.wordMatchAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'KnowledgeId': knowledgeId,
      'QuestionIdOne': questionIdOne,
      'AnswerOne': answerOne,
      'QuestionIdTwo': questionIdTwo,
      'AnswerTwo': answerTwo,
      'Interpretation': interpretation,
      'WordMatchAnswer': wordMatchAnswer,
    };
  }
}
