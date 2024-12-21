part of 'index.dart';

class LearningList extends SingleIdEntity {
  final String title;
  final String learnerId;
  final User? learner;
  final List<LearningListKnowledge> learningListKnowledges;
  final List<Learning> learntKnowledges;
  final int learntKnowledgeCount;
  final List<Knowledge> notLearntKnowledges;
  final int notLearntKnowledgeCount;
  bool get noKnowledge =>
      learntKnowledges.isEmpty && notLearntKnowledges.isEmpty;

  LearningList({
    required super.id,
    required super.createdAt,
    required this.title,
    required this.learnerId,
    this.learner,
    this.learningListKnowledges = const [],
    this.learntKnowledges = const [],
    required this.learntKnowledgeCount,
    this.notLearntKnowledges = const [],
    required this.notLearntKnowledgeCount,
  });

  factory LearningList.fromJson(Map<String, dynamic> json) {
    return LearningList(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      learnerId: json['learnerId'],
      learner: json['learner'] != null ? User.fromJson(json['learner']) : null,
      learningListKnowledges: (json['learningListKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => LearningListKnowledge.fromJson(e))
          .toList(),
      learntKnowledges: (json['learntKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => Learning.fromJson(e))
          .toList(),
      learntKnowledgeCount: json['learntKnowledgeCount'],
      notLearntKnowledges: (json['notLearntKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => Knowledge.fromJson(e))
          .toList(),
      notLearntKnowledgeCount: json['notLearntKnowledgeCount'],
    );
  }

  LearningList copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? learnerId,
    User? learner,
    List<LearningListKnowledge>? learningListKnowledges,
    List<Learning>? learntKnowledges,
    int? learntKnowledgeCount,
    List<Knowledge>? notLearntKnowledges,
    int? notLearntKnowledgeCount,
  }) {
    return LearningList(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      learnerId: learnerId ?? this.learnerId,
      learner: learner ?? this.learner,
      learningListKnowledges:
          learningListKnowledges ?? this.learningListKnowledges,
      learntKnowledges: learntKnowledges ?? this.learntKnowledges,
      learntKnowledgeCount: learntKnowledgeCount ?? this.learntKnowledgeCount,
      notLearntKnowledges: notLearntKnowledges ?? this.notLearntKnowledges,
      notLearntKnowledgeCount:
          notLearntKnowledgeCount ?? this.notLearntKnowledgeCount,
    );
  }

  bool containsKnowledge(String id) {
    return learntKnowledges.any((element) => element.knowledgeId == id) ||
        notLearntKnowledges.any((element) => element.id == id);
  }
}
