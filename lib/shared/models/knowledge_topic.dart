part of 'index.dart';

class KnowledgeTopic extends SingleIdEntity {
  final String title;
  final int? order;
  final String? parentId;
  final KnowledgeTopic? parent;
  final List<KnowledgeTopic> children;
  final List<KnowledgeTopicKnowledge> knowledgeTopicKnowledges;

  KnowledgeTopic({
    required super.id,
    required super.createdAt,
    required this.title,
    this.order,
    this.parentId,
    this.parent,
    this.children = const [],
    this.knowledgeTopicKnowledges = const [],
  });

  factory KnowledgeTopic.fromJson(Map<String, dynamic> json) {
    return KnowledgeTopic(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      order: json['order'],
      parentId: json['parentId'],
      parent: json['parent'] != null
          ? KnowledgeTopic.fromJson(json['parent'])
          : null,
      children: (json['children'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => KnowledgeTopic.fromJson(e))
              .toList() ??
          [],
      knowledgeTopicKnowledges:
          (json['knowledgeTopicKnowledges'] as List<dynamic>?)
                  ?.whereType<Map<String, dynamic>>()
                  .map((e) => KnowledgeTopicKnowledge.fromJson(e))
                  .toList() ??
              [],
    );
  }

  KnowledgeTopic copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    int? order,
    String? parentId,
    KnowledgeTopic? parent,
    List<KnowledgeTopic>? children,
    List<KnowledgeTopicKnowledge>? knowledgeTopicKnowledges,
  }) {
    return KnowledgeTopic(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      order: order ?? this.order,
      parentId: parentId ?? this.parentId,
      parent: parent ?? this.parent,
      children: children ?? this.children,
      knowledgeTopicKnowledges:
          knowledgeTopicKnowledges ?? this.knowledgeTopicKnowledges,
    );
  }

  bool recursiveContains(String searchValue) {
    if (title.toLowerCase().contains(searchValue.toLowerCase())) {
      return true;
    }
    for (final topic in children) {
      if (topic.recursiveContains(searchValue)) {
        return true;
      }
    }
    return false;
  }
}
