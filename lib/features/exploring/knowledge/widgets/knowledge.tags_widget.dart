import 'package:flutter/material.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/index.dart';

class KnowledgeTagsWidget extends StatelessWidget {
  final Knowledge knowledge;

  const KnowledgeTagsWidget({super.key, required this.knowledge});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              knowledge.level.toJson(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          ...knowledge.knowledgeTypeKnowledges.map(
            (item) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.knowledgeType?.name ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          ...knowledge.knowledgeTopicKnowledges.map(
            (item) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.hint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.knowledgeTopic?.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
