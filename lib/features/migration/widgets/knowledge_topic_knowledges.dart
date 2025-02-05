import 'package:flutter/material.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';

class KnowledgeTopicKnowledges extends StatefulWidget {
  final KnowledgeTopic topic;
  final List<String> selectedKnowledgeIds;
  final Function(String) onKnowledgeSelect;

  const KnowledgeTopicKnowledges({
    super.key,
    required this.topic,
    required this.selectedKnowledgeIds,
    required this.onKnowledgeSelect,
  });

  @override
  State<KnowledgeTopicKnowledges> createState() =>
      _KnowledgeTopicKnowledgesState();
}

class _KnowledgeTopicKnowledgesState extends State<KnowledgeTopicKnowledges> {
  bool _showKnowledges = true;

  void _toggleShowKnowledges() {
    setState(() {
      _showKnowledges = !_showKnowledges;
    });
  }

  @override
  Widget build(BuildContext context) {
    var anySelected = widget.selectedKnowledgeIds.any((e) => widget
        .topic.knowledgeTopicKnowledges
        .any((ktk) => ktk.knowledgeId == e));
    var anyLearning = widget.topic.knowledgeTopicKnowledges
        .any((ktk) => ktk.knowledge?.currentUserLearning != null);
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 12.0, horizontal: _showKnowledges ? 0 : 24),
      decoration: BoxDecoration(
        border: Border.all(
            width: anyLearning ? 2 : 1,
            color: _showKnowledges
                ? AppColors.hint
                : anySelected
                    ? AppColors.secondary
                    : anyLearning
                        ? Theme.of(context).primaryColor
                        : AppColors.hint),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _toggleShowKnowledges,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.topic.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(_showKnowledges
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          if (_showKnowledges)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: widget.topic.knowledgeTopicKnowledges.map((ktk) {
                  bool isSelected =
                      widget.selectedKnowledgeIds.contains(ktk.knowledgeId);
                  return GestureDetector(
                    onTap: ktk.knowledge?.currentUserLearning != null
                        ? null
                        : () => widget.onKnowledgeSelect(ktk.knowledgeId),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: isSelected ? 2 : 1,
                          color: isSelected
                              ? AppColors.secondary
                              : ktk.knowledge?.currentUserLearning == null
                                  ? AppColors.hint
                                  : AppColors.success.withOpacity(0.7),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        ktk.knowledge?.title ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
