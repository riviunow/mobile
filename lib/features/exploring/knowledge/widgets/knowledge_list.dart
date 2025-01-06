import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/add_remove_knowledges_bloc.dart';
import 'package:udetxen/features/learning/learning_list/models/add_remove_knowledges.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class KnowledgeList extends StatelessWidget {
  final List<Knowledge> knowledges;
  final bool hasNext;
  final VoidCallback onLoadMore;
  final LearningList? learningList;
  final bool isSelectionMode;
  final Set<String> selectedKnowledgeIds;
  final ValueChanged<Knowledge> onKnowledgeSelected;

  const KnowledgeList({
    super.key,
    required this.knowledges,
    required this.hasNext,
    required this.onLoadMore,
    this.learningList,
    required this.isSelectionMode,
    required this.selectedKnowledgeIds,
    required this.onKnowledgeSelected,
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
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 80, top: 20),
                    child: Loading(
                      loaderType: LoaderType.wave,
                    ))
                : const Center(child: Text('No more items to load'));
          }
          final knowledge = knowledges[index];
          final isSelected = selectedKnowledgeIds.contains(knowledge.id);

          return Stack(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.secondary.withOpacity(0.7)
                        : knowledge.currentUserLearning != null
                            ? Theme.of(context).primaryColor.withOpacity(0.8)
                            : AppColors.hint.withOpacity(0.4),
                    width: 3,
                  ),
                ),
                elevation: 4,
                child: ListTile(
                  onTap: () => onKnowledgeSelected(knowledge),
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    knowledge.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (knowledge.currentUserLearning != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${knowledge.currentUserLearning?.calculateTimeLeft()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (learningList != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<AddRemoveKnowledgesBloc>().add(
                                  AddRemoveKnowledgesRequested(
                                      AddRemoveKnowledgesRequest(
                                          isAdd: !learningList!
                                              .containsKnowledge(knowledge.id),
                                          knowledgeIds: [knowledge.id],
                                          learningListId: learningList!.id)));
                            },
                            icon: Icon(
                              learningList!.containsKnowledge(knowledge.id)
                                  ? Icons.remove_circle_outline
                                  : Icons.add_circle_outline,
                              color: Colors.white,
                            ),
                            label: Text(
                              learningList!.containsKnowledge(knowledge.id)
                                  ? 'Remove from ${learningList!.title.length > 12 ? '${learningList!.title.substring(0, 12)}...' : learningList!.title}'
                                  : 'Add to ${learningList!.title.length > 12 ? '${learningList!.title.substring(0, 12)}...' : learningList!.title}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: learningList!
                                        .containsKnowledge(knowledge.id)
                                    ? Colors.red
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 6)),
                          ),
                        ),
                    ],
                  ),
                  trailing: isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            onKnowledgeSelected(knowledge);
                          },
                        )
                      : PopupMenuButton<String>(
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
              ),
              Positioned(
                top: 2,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    knowledge.level.toJson(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
