import 'package:flutter/material.dart';
import 'package:rvnow/shared/models/index.dart';

import 'knowledge_topic_item.dart';
import 'knowledge_topic_knowledges.dart';

class KnowledgeTopicList extends StatelessWidget {
  final List<KnowledgeTopic> knowledgeTopics;
  final List<String> selectedKnowledgeIds;
  final Function(String) onKnowledgeSelect;
  final Function(KnowledgeTopic) onTopicTap;

  const KnowledgeTopicList({
    super.key,
    required this.knowledgeTopics,
    required this.selectedKnowledgeIds,
    required this.onKnowledgeSelect,
    required this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: knowledgeTopics.map((topic) {
            if (topic.knowledgeTopicKnowledges.isEmpty) {
              return KnowledgeTopicItem(
                topic: topic,
                onTap: () => onTopicTap(topic),
              );
            } else {
              return KnowledgeTopicKnowledges(
                topic: topic,
                selectedKnowledgeIds: selectedKnowledgeIds,
                onKnowledgeSelect: onKnowledgeSelect,
              );
            }
          }).toList()
            ..add(const SizedBox(height: 100)),
        ),
      ),
    );
  }
}
