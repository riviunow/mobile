part of 'index.dart';

class Material extends SingleIdEntity {
  final MaterialType type;
  final String content;
  final String knowledgeId;
  final int? order;
  final String? parentId;
  final List<Material> children;

  Material({
    required super.id,
    required super.createdAt,
    required this.type,
    required this.content,
    required this.knowledgeId,
    this.order,
    this.parentId,
    this.children = const [],
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      type: MaterialTypeExtension.fromJson(json['type']),
      content: json['content'],
      knowledgeId: json['knowledgeId'],
      order: json['order'],
      parentId: json['parentId'],
      children: (json['children'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => Material.fromJson(e))
              .toList() ??
          [],
    );
  }

  Material copyWith({
    String? id,
    DateTime? createdAt,
    MaterialType? type,
    String? content,
    String? knowledgeId,
    int? order,
    String? parentId,
    List<Material>? children,
  }) {
    return Material(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      content: content ?? this.content,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      order: order ?? this.order,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }
}
