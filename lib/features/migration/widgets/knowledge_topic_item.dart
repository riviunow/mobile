import 'package:flutter/material.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';

class KnowledgeTopicItem extends StatelessWidget {
  final KnowledgeTopic topic;
  final VoidCallback onTap;

  const KnowledgeTopicItem({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.hint),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                topic.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
