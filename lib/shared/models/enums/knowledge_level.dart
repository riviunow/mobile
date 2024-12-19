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
}
