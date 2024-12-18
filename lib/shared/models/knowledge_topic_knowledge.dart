part of 'index.dart';

class KnowledgeTopicKnowledge {
  final String knowledgeTopicId;
  final KnowledgeTopic? knowledgeTopic;
  final String knowledgeId;
  final Knowledge? knowledge;

  KnowledgeTopicKnowledge({
    required this.knowledgeTopicId,
    this.knowledgeTopic,
    required this.knowledgeId,
    this.knowledge,
  });

  factory KnowledgeTopicKnowledge.fromJson(Map<String, dynamic> json) {
    return KnowledgeTopicKnowledge(
      knowledgeTopicId: json['knowledgeTopicId'],
      knowledgeTopic: json['knowledgeTopic'] != null
          ? KnowledgeTopic.fromJson(json['knowledgeTopic'])
          : null,
      knowledgeId: json['knowledgeId'],
      knowledge: json['knowledge'] != null
          ? Knowledge.fromJson(json['knowledge'])
          : null,
    );
  }

  KnowledgeTopicKnowledge copyWith({
    String? knowledgeTopicId,
    KnowledgeTopic? knowledgeTopic,
    String? knowledgeId,
    Knowledge? knowledge,
  }) {
    return KnowledgeTopicKnowledge(
      knowledgeTopicId: knowledgeTopicId ?? this.knowledgeTopicId,
      knowledgeTopic: knowledgeTopic ?? this.knowledgeTopic,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledge: knowledge ?? this.knowledge,
    );
  }
}
