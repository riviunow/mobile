part of 'index.dart';

class SubjectKnowledge {
  final String subjectId;
  final Subject? subject;
  final String knowledgeId;
  final Knowledge? knowledge;

  SubjectKnowledge({
    required this.subjectId,
    this.subject,
    required this.knowledgeId,
    this.knowledge,
  });

  factory SubjectKnowledge.fromJson(Map<String, dynamic> json) {
    return SubjectKnowledge(
      subjectId: json['subjectId'],
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      knowledgeId: json['knowledgeId'],
      knowledge: json['knowledge'] != null
          ? Knowledge.fromJson(json['knowledge'])
          : null,
    );
  }

  SubjectKnowledge copyWith({
    String? subjectId,
    Subject? subject,
    String? knowledgeId,
    Knowledge? knowledge,
  }) {
    return SubjectKnowledge(
      subjectId: subjectId ?? this.subjectId,
      subject: subject ?? this.subject,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledge: knowledge ?? this.knowledge,
    );
  }
}
