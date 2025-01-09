import 'package:easy_localization/easy_localization.dart';
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
             SnackBar(content: Text('knowledge_deleted_successfully'.tr())),
          );
          Navigator.pop(context);
        } else if (state is DeleteKnowledgeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
          );
        }
      },
      child: AlertDialog(
        title: Text('delete_knowledge'.tr()),
        content: Text('are_you_sure_to_delete_this_knowledge'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<DeleteKnowledgeBloc>()
                  .add(DeleteKnowledge(knowledge.id));
            },
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }
}
