import 'package:udetxen/shared/models/enums/knowledge_level.dart';

class UpdateKnowledgeRequest {
  final String id;
  final String title;
  final KnowledgeLevel level;

  UpdateKnowledgeRequest({
    required this.id,
    required this.title,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'level': level.toJson(),
    };
  }
}
