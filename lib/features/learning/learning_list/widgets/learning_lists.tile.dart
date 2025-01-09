import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/features/learning/learning_list/screens/get_learning_list_by_id_screen.dart';

class LearningListsTile extends StatelessWidget {
  final LearningList learningList;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<LearningList> onLearningListSelected;

  const LearningListsTile({
    super.key,
    required this.learningList,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onLearningListSelected,
  });

  @override
  Widget build(BuildContext context) {
    var learntCount = learningList.learntKnowledgeCount;
    var notLearntCount = learningList.notLearntKnowledgeCount;
    var total = learntCount + notLearntCount;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: isSelected ? AppColors.secondary.withOpacity(0.5) : null,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: isSelectionMode
            ? () => onLearningListSelected(learningList)
            : () => Navigator.push(
                context, GetLearningListByIdScreen.route(learningList.id)),
        title: Text(
          learningList.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (total > 0)
              Text('$total ${"knowledge(s)".tr()}',
                  style: const TextStyle(color: AppColors.success)),
            if (total > 0 && learntCount < total && learntCount > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('${"learnt".tr()} $learntCount/$total'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: learntCount / total,
                      backgroundColor: AppColors.hint,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
            if (learntCount == 0) ...[
              const SizedBox(height: 8),
              Text('no_knowledge_learnt_yet'.tr(),
                  style: const TextStyle(color: AppColors.warning)),
            ],
          ],
        ),
        trailing: isSelectionMode
            ? Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: isSelected ? Theme.of(context).primaryColor : null,
              )
            : null,
      ),
    );
  }
}
