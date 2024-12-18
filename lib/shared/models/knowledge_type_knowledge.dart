part of 'index.dart';

class KnowledgeTypeKnowledge {
  final String knowledgeTypeId;
  final KnowledgeType? knowledgeType;
  final String knowledgeId;
  final Knowledge? knowledge;

  KnowledgeTypeKnowledge({
    required this.knowledgeTypeId,
    this.knowledgeType,
    required this.knowledgeId,
    this.knowledge,
  });

  factory KnowledgeTypeKnowledge.fromJson(Map<String, dynamic> json) {
    return KnowledgeTypeKnowledge(
      knowledgeTypeId: json['knowledgeTypeId'],
      knowledgeType: json['knowledgeType'] != null
          ? KnowledgeType.fromJson(json['knowledgeType'])
          : null,
      knowledgeId: json['knowledgeId'],
      knowledge: json['knowledge'] != null
          ? Knowledge.fromJson(json['knowledge'])
          : null,
    );
  }

  KnowledgeTypeKnowledge copyWith({
    String? knowledgeTypeId,
    KnowledgeType? knowledgeType,
    String? knowledgeId,
    Knowledge? knowledge,
  }) {
    return KnowledgeTypeKnowledge(
      knowledgeTypeId: knowledgeTypeId ?? this.knowledgeTypeId,
      knowledgeType: knowledgeType ?? this.knowledgeType,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledge: knowledge ?? this.knowledge,
    );
  }
}
