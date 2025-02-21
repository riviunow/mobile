part of 'index.dart';

class LearningList extends SingleIdEntity {
  final String title;
  final String learnerId;
  final User? learner;
  final List<LearningListKnowledge> learningListKnowledges;
  final int learntKnowledgeCount;
  final int notLearntKnowledgeCount;
  List<Knowledge> get learntKnowledges => learningListKnowledges
      .where((e) => e.knowledge?.currentUserLearning != null)
      .map((e) => e.knowledge)
      .whereType<Knowledge>()
      .toList();
  List<Knowledge> get notLearntKnowledges => learningListKnowledges
      .where((e) => e.knowledge?.currentUserLearning == null)
      .map((e) => e.knowledge)
      .whereType<Knowledge>()
      .toList();
  bool get noKnowledge =>
      learntKnowledges.isEmpty && notLearntKnowledges.isEmpty;

  LearningList({
    required super.id,
    required super.createdAt,
    required this.title,
    required this.learnerId,
    this.learner,
    this.learningListKnowledges = const [],
    required this.learntKnowledgeCount,
    required this.notLearntKnowledgeCount,
  });

  factory LearningList.fromJson(Map<String, dynamic> json) {
    return LearningList(
      id: json['id'],
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      title: json['title'],
      learnerId: json['learnerId'],
      learner: json['learner'] != null ? User.fromJson(json['learner']) : null,
      learningListKnowledges: (json['learningListKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => LearningListKnowledge.fromJson(e))
          .toList(),
      learntKnowledgeCount: json['learntKnowledgeCount'],
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
    int? learntKnowledgeCount,
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
      learntKnowledgeCount: learntKnowledgeCount ?? this.learntKnowledgeCount,
      notLearntKnowledgeCount:
          notLearntKnowledgeCount ?? this.notLearntKnowledgeCount,
    );
  }

  bool containsKnowledge(String id) {
    return learntKnowledges.any((element) => element.id == id) ||
        notLearntKnowledges.any((element) => element.id == id);
  }
}
