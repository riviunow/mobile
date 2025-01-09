import 'package:easy_localization/easy_localization.dart';

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

  String toStr() {
    switch (this) {
      case KnowledgeVisibility.public:
        return 'knowledge_visibility.public'.tr();
      case KnowledgeVisibility.private:
        return 'knowledge_visibility.private'.tr();
    }
  }
}
