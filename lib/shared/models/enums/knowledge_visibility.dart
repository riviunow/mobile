enum KnowledgeVisibility {
  public,
  private,
}

extension KnowledgeVisibilityExtension on KnowledgeVisibility {
  static KnowledgeVisibility fromJson(String json) {
    switch (json) {
      case 'Public':
        return KnowledgeVisibility.public;
      case 'Private':
        return KnowledgeVisibility.private;
      default:
        throw ArgumentError('Unknown visibility: $json');
    }
  }

  String toJson() {
    switch (this) {
      case KnowledgeVisibility.public:
        return 'Public';
      case KnowledgeVisibility.private:
        return 'Private';
    }
  }
}
