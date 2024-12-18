part of 'index.dart';

class KnowledgeType extends SingleIdEntity {
  final String name;
  final String? parentId;
  final KnowledgeType? parent;
  final List<KnowledgeType> children;
  final List<KnowledgeTypeKnowledge> knowledgeTypeKnowledges;

  KnowledgeType({
    required super.id,
    required super.createdAt,
    required this.name,
    this.parentId,
    this.parent,
    this.children = const [],
    this.knowledgeTypeKnowledges = const [],
  });

  factory KnowledgeType.fromJson(Map<String, dynamic> json) {
    return KnowledgeType(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      name: json['name'],
      parentId: json['parentId'],
      parent: json['parent'] != null
          ? KnowledgeType.fromJson(json['parent'])
          : null,
      children: (json['children'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => KnowledgeType.fromJson(e))
              .toList() ??
          [],
      knowledgeTypeKnowledges:
          (json['knowledgeTypeKnowledges'] as List<dynamic>?)
                  ?.whereType<Map<String, dynamic>>()
                  .map((e) => KnowledgeTypeKnowledge.fromJson(e))
                  .toList() ??
              [],
    );
  }

  KnowledgeType copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? parentId,
    KnowledgeType? parent,
    List<KnowledgeType>? children,
    List<KnowledgeTypeKnowledge>? knowledgeTypeKnowledges,
  }) {
    return KnowledgeType(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      parent: parent ?? this.parent,
      children: children ?? this.children,
      knowledgeTypeKnowledges:
          knowledgeTypeKnowledges ?? this.knowledgeTypeKnowledges,
    );
  }
}
