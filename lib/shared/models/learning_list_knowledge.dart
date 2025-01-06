part of 'index.dart';

class LearningListKnowledge {
  final String learningListId;
  final LearningList? learningList;
  final String knowledgeId;
  final Knowledge? knowledge;
  final int? order;

  LearningListKnowledge({
    required this.learningListId,
    this.learningList,
    required this.knowledgeId,
    this.knowledge,
    this.order,
  });

  factory LearningListKnowledge.fromJson(Map<String, dynamic> json) {
    return LearningListKnowledge(
      learningListId: json['learningListId'],
      learningList: json['learningList'] != null
          ? LearningList.fromJson(json['learningList'])
          : null,
      knowledgeId: json['knowledgeId'],
      knowledge: json['knowledge'] != null
          ? Knowledge.fromJson(json['knowledge'])
          : null,
      order: json['order'],
    );
  }

  LearningListKnowledge copyWith({
    String? learningListId,
    LearningList? learningList,
    String? knowledgeId,
    Knowledge? knowledge,
    int? order,
    bool? deleted,
  }) {
    return LearningListKnowledge(
      learningListId: learningListId ?? this.learningListId,
      learningList: learningList ?? this.learningList,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledge: knowledge ?? this.knowledge,
      order: order ?? this.order,
    );
  }
}
