import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/creating/knowledge/blocs/delete_knowledge_bloc.dart';
import 'package:udetxen/shared/models/index.dart';

class DeleteKnowledgeDialog extends StatelessWidget {
  final Knowledge knowledge;

  const DeleteKnowledgeDialog({super.key, required this.knowledge});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteKnowledgeBloc, DeleteKnowledgeState>(
      listener: (context, state) {
        if (state is DeleteKnowledgeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Knowledge deleted successfully!')),
          );
          Navigator.pop(context);
        } else if (state is DeleteKnowledgeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Delete Knowledge'),
        content: const Text('Are you sure you want to delete this knowledge?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<DeleteKnowledgeBloc>()
                  .add(DeleteKnowledge(knowledge.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
