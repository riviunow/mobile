import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/screens/knowledge_detail_screen.dart';
import 'package:udetxen/features/learning/learning_list/blocs/add_remove_knowledge_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_list_by_id_bloc.dart';
import 'package:udetxen/features/learning/learning_list/models/add_remove_knowledge.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class SearchKnowledgeList extends StatelessWidget {
  final List<Knowledge> knowledges;
  final bool hasNext;
  final VoidCallback onLoadMore;
  final String? learningListId;

  const SearchKnowledgeList({
    super.key,
    required this.knowledges,
    required this.hasNext,
    required this.onLoadMore,
    this.learningListId,
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
      child: BlocBuilder<GetLearningListByIdBloc, GetLearningListByIdState>(
        builder: (context, state) {
          LearningList? learningList;
          if (learningListId != null && state is GetLearningListByIdSuccess) {
            learningList = state.learningList;
          }

          return ListView.builder(
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
                  onTap: () => Navigator.push(context,
                      KnowledgeDetailScreen.route(knowledge: knowledge)),
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
                      if (knowledge.creator != null)
                        Text('Creator: ${knowledge.creator!.userName}'),
                      if (knowledge.publicationRequest != null)
                        Text(
                            'Publication Request: ${knowledge.publicationRequest!.status}'),
                      const SizedBox(height: 8),
                      if (knowledge.currentUserLearning == null)
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Learnt'),
                        ),
                      if (learningList != null)
                        ElevatedButton(
                          onPressed: () {
                            context.read<AddRemoveKnowledgeBloc>().add(
                                AddRemoveKnowledgeRequested(
                                    AddRemoveKnowledgeRequest(
                                        knowledgeId: knowledge.id,
                                        learningListId: learningList!.id)));
                          },
                          child: Text(
                              learningList.containsKnowledge(knowledge.id)
                                  ? 'Remove from ${learningList.title}'
                                  : 'Add to ${learningList.title}'),
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {},
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Option 1',
                        child: Text('Option 1'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Option 2',
                        child: Text('Option 2'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
