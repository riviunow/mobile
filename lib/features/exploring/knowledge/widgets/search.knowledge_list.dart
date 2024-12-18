import 'package:flutter/material.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class SearchKnowledgeList extends StatelessWidget {
  final List<Knowledge> knowledges;
  final bool hasNext;
  final VoidCallback onLoadMore;

  const SearchKnowledgeList({
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
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                knowledge.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visibility: ${knowledge.visibility}'),
                  Text('Level: ${knowledge.level}'),
                  if (knowledge.creator != null)
                    Text('Creator: ${knowledge.creator!.userName}'),
                  if (knowledge.publicationRequest != null)
                    Text(
                        'Publication Request: ${knowledge.publicationRequest!.status}'),
                  if (knowledge.currentUserLearning != null)
                    const Text('Learnt'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
