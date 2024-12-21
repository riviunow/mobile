import 'package:flutter/material.dart';
import 'package:udetxen/shared/models/index.dart';

import 'by_id.knowledge_card.dart';

class ByIdKnowledgesList extends StatelessWidget {
  final LearningList learningList;

  const ByIdKnowledgesList({super.key, required this.learningList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ...learningList.learntKnowledges.map((learningListKnowledge) {
          final knowledge = learningListKnowledge.knowledge;
          return knowledge != null
              ? ByIdKnowledgeCard(
                  knowledge: knowledge, learningListId: learningList.id)
              : const SizedBox.shrink();
        }),
        const SizedBox(height: 16),
        ...learningList.notLearntKnowledges.map((knowledge) {
          return ByIdKnowledgeCard(
              knowledge: knowledge, learningListId: learningList.id);
        }),
      ],
    );
  }
}
