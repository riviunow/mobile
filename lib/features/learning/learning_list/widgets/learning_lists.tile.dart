import 'package:flutter/material.dart';
import 'package:udetxen/features/learning/learning_list/screens/get_learning_list_by_id_screen.dart';
import 'package:udetxen/shared/models/index.dart';

class LearningListsTile extends StatelessWidget {
  final LearningList learningList;

  const LearningListsTile({super.key, required this.learningList});

  @override
  Widget build(BuildContext context) {
    var learntCount = learningList.learntKnowledgeCount;
    var notLearntCount = learningList.notLearntKnowledgeCount;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () => Navigator.push(
            context, GetLearningListByIdScreen.route(learningList.id)),
        title: Text(
          learningList.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (learntCount > 0)
              Text('Learnt: $learntCount',
                  style: const TextStyle(color: Colors.green)),
            if (learntCount == 0)
              const Text('No knowledge learnt',
                  style: TextStyle(color: Colors.red)),
            if (notLearntCount > 0)
              Text('Not learnt: $notLearntCount',
                  style: const TextStyle(color: Colors.orange)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
