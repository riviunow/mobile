import 'package:image_picker/image_picker.dart';
import 'package:rvnow/shared/models/enums/knowledge_level.dart';
import 'package:rvnow/shared/models/enums/material_type.dart';

class MaterialParams {
  final MaterialType type;
  final String content;
  final int? order;
  final List<MaterialParams> children;

  MaterialParams setOrder({int? newOrder}) {
    return MaterialParams(
      type: type,
      content: content,
      order: newOrder,
      children: children
          .asMap()
          .entries
          .map((entry) => entry.value.setOrder(newOrder: entry.key))
          .toList(),
    );
  }

  MaterialParams({
    required this.type,
    required this.content,
    this.order,
    this.children = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'content': content,
      'order': order,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }

  MaterialParams copyWith({
    MaterialType? type,
    String? content,
    int? order,
    List<MaterialParams>? children,
  }) {
    return MaterialParams(
      type: type ?? this.type,
      content: content ?? this.content,
      order: order ?? this.order,
      children: children ?? this.children,
    );
  }
}

class CreateKnowledgeRequest {
  final String title;
  final KnowledgeLevel level;
  final List<String> knowledgeTypeIds;
  final List<String> knowledgeTopicIds;
  final List<MaterialParams> materials;
  final XFile? audio;
  final XFile? image;
  final XFile? video;

  CreateKnowledgeRequest({
    required this.title,
    required this.level,
    this.knowledgeTypeIds = const [],
    this.knowledgeTopicIds = const [],
    this.materials = const [],
    this.audio,
    this.image,
    this.video,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'level': level.toJson(),
      'knowledgeTypeIds': knowledgeTypeIds,
      'knowledgeTopicIds': knowledgeTopicIds,
      'materials': materials.map((e) => e.toJson()).toList(),
    };
  }

  List<(XFile, String)> get files {
    final files = <(XFile, String)>[];

    if (audio != null) {
      files.add((audio!, 'Audio'));
    }

    if (image != null) {
      files.add((image!, 'Image'));
    }

    if (video != null) {
      files.add((video!, 'Video'));
    }

    return files;
  }
}
