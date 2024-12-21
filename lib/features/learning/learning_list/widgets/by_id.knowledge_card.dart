import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/screens/knowledge_detail_screen.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/index.dart';

import '../blocs/add_remove_knowledge_bloc.dart';
import '../models/add_remove_knowledge.dart';

class ByIdKnowledgeCard extends StatelessWidget {
  final Knowledge knowledge;
  final String learningListId;

  const ByIdKnowledgeCard(
      {super.key, required this.knowledge, required this.learningListId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(knowledge.title),
        subtitle: Text('Level: ${knowledge.level.toJson()}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeDetailScreen(knowledge: knowledge),
            ),
          );
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: const Text(
                      'Are you sure you want to delete this knowledge?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );

            if (confirmed == true) {
              context.read<AddRemoveKnowledgeBloc>().add(
                  AddRemoveKnowledgeRequested(AddRemoveKnowledgeRequest(
                      knowledgeId: knowledge.id,
                      learningListId: learningListId)));
            }
          },
        ),
      ),
    );
  }
}
