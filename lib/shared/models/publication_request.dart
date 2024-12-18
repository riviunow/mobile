part of 'index.dart';

class PublicationRequest extends SingleIdEntity {
  final String knowledgeId;
  final Knowledge? knowledge;
  final String status;

  PublicationRequest({
    required super.id,
    required super.createdAt,
    required this.knowledgeId,
    this.knowledge,
    required this.status,
  });

  factory PublicationRequest.fromJson(Map<String, dynamic> json) {
    return PublicationRequest(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      knowledgeId: json['knowledgeId'],
      knowledge: json['knowledge'] != null
          ? Knowledge.fromJson(json['knowledge'])
          : null,
      status: json['status'],
    );
  }

  PublicationRequest copyWith({
    String? id,
    DateTime? createdAt,
    String? knowledgeId,
    Knowledge? knowledge,
    String? status,
  }) {
    return PublicationRequest(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledge: knowledge ?? this.knowledge,
      status: status ?? this.status,
    );
  }
}
