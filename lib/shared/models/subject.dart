part of 'index.dart';

class Subject extends SingleIdEntity {
  final String name;
  final String description;
  final String photo;
  final List<TrackSubject> trackSubjects;
  final List<SubjectKnowledge> subjectKnowledges;
  final int knowledgeCount;
  final int userLearningCount;

  Subject({
    required super.id,
    required super.createdAt,
    required this.name,
    required this.description,
    required this.photo,
    this.trackSubjects = const [],
    this.subjectKnowledges = const [],
    required this.knowledgeCount,
    required this.userLearningCount,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      trackSubjects: (json['trackSubjects'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => TrackSubject.fromJson(e))
              .toList() ??
          [],
      subjectKnowledges: (json['subjectKnowledges'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => SubjectKnowledge.fromJson(e))
              .toList() ??
          [],
      knowledgeCount: json['knowledgeCount'],
      userLearningCount: json['userLearningCount'],
    );
  }

  Subject copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? description,
    String? photo,
    List<TrackSubject>? trackSubjects,
    List<SubjectKnowledge>? subjectKnowledges,
    int? knowledgeCount,
    int? userLearningCount,
  }) {
    return Subject(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      trackSubjects: trackSubjects ?? this.trackSubjects,
      subjectKnowledges: subjectKnowledges ?? this.subjectKnowledges,
      knowledgeCount: knowledgeCount ?? this.knowledgeCount,
      userLearningCount: userLearningCount ?? this.userLearningCount,
    );
  }
}
