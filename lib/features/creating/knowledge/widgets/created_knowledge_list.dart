import 'package:flutter/material.dart';
import 'package:udetxen/features/exploring/knowledge/screens/knowledge_detail_screen.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/enums/knowledge_visibility.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../screens/update_knowledge_screen.dart';
import 'delete_knowledge_dialog.dart';

class CreatedKnowledgeList extends StatelessWidget {
  final List<Knowledge> knowledges;
  final bool hasNext;
  final VoidCallback onLoadMore;

  const CreatedKnowledgeList({
    super.key,
    required this.knowledges,
    required this.hasNext,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            hasNext) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: knowledges.length + 1,
        itemBuilder: (context, index) {
          if (index == knowledges.length) {
            return hasNext
                ? const Center(
                    child: Loading(
                    loaderType: LoaderType.wave,
                  ))
                : const Center(child: Text('No more items to load'));
          }
          final knowledge = knowledges[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: ListTile(
              onTap: () => Navigator.push(
                  context, KnowledgeDetailScreen.route(knowledge: knowledge)),
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                knowledge.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Level: ${knowledge.level.toJson()}'),
                  const SizedBox(height: 8),
                  Text('Status: ${knowledge.visibility.toJson()}'),
                  if (knowledge.publicationRequest != null)
                    Text(
                        'Publication Request: ${knowledge.publicationRequest!.status}'),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (String result) {
                  if (result == 'update') {
                    Navigator.push(
                      context,
                      UpdateKnowledgeScreen.route(knowledge),
                    );
                  } else if (result == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DeleteKnowledgeDialog(knowledge: knowledge),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'update',
                    enabled:
                        knowledge.visibility == KnowledgeVisibility.private,
                    child: const Text('Update'),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    enabled:
                        knowledge.visibility == KnowledgeVisibility.private,
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
