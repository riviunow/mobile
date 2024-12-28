import 'package:flutter/material.dart';

enum Task {
  Learn,
  Review,
}

class PlayingWidget {
  final PlayingWidgetType type;
  final Widget widget;
  final int group;
  final String? knowledgeId;

  PlayingWidget(
      {required this.type,
      required this.widget,
      required this.group,
      this.knowledgeId});
}

enum PlayingWidgetType {
  FlashCard,
  GamingBoard,
  WordMatch,
}

class Answer {
  final String knowledgeId;
  final String questionId;
  final String gameOptionAnswerId;

  Answer({
    required this.knowledgeId,
    required this.questionId,
    required this.gameOptionAnswerId,
  });
}

class KnowledgeAnswer {
  final int group;
  final String knowledgeId;
  final List<(String, String)> questionAnswerPair;

  KnowledgeAnswer({
    required this.group,
    required this.knowledgeId,
    required this.questionAnswerPair,
  });
}

class WordMatchAnswer {
  final String interpretation;
  final String wordMatchAnswer;

  WordMatchAnswer({
    required this.interpretation,
    required this.wordMatchAnswer,
  });
}
