import 'package:flutter/material.dart';
import 'package:rvnow/shared/models/index.dart';

class KnowledgeList extends StatelessWidget {
  final List<Knowledge> knowledges;

  const KnowledgeList({super.key, required this.knowledges});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: knowledges.length,
              itemBuilder: (context, index) {
                final knowledge = knowledges[index];
                return ListTile(
                  title: Text(knowledge.title),
                  subtitle: Text(knowledge.currentUserLearning != null
                      ? 'Learnt'
                      : 'Not yet learnt'),
                );
              },
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
