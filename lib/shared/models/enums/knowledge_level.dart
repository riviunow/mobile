import 'package:easy_localization/easy_localization.dart';

enum KnowledgeLevel {
  beginner,
  intermediate,
  expert,
}

extension KnowledgeLevelExtension on KnowledgeLevel {
  static KnowledgeLevel fromJson(String json) {
    switch (json) {
      case 'Beginner':
        return KnowledgeLevel.beginner;
      case 'Intermediate':
        return KnowledgeLevel.intermediate;
      case 'Expert':
        return KnowledgeLevel.expert;
      default:
        throw ArgumentError('Unknown knowledge level: $json');
    }
  }

  String toJson() {
    switch (this) {
      case KnowledgeLevel.beginner:
        return 'Beginner';
      case KnowledgeLevel.intermediate:
        return 'Intermediate';
      case KnowledgeLevel.expert:
        return 'Expert';
    }
  }

  String toStr() {
    switch (this) {
      case KnowledgeLevel.beginner:
        return 'knowledge_level.beginner'.tr();
      case KnowledgeLevel.intermediate:
        return 'knowledge_level.intermediate'.tr();
      case KnowledgeLevel.expert:
        return 'knowledge_level.expert'.tr();
    }
  }
}
