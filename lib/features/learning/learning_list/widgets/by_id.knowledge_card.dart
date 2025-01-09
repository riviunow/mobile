import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/screens/knowledge_detail_screen.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/index.dart';

import '../blocs/add_remove_knowledges_bloc.dart';
import '../models/add_remove_knowledges.dart';

class ByIdKnowledgeCard extends StatefulWidget {
  final Knowledge knowledge;
  final String learningListId;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<Knowledge> onKnowledgeSelected;

  const ByIdKnowledgeCard({
    super.key,
    required this.knowledge,
    required this.learningListId,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onKnowledgeSelected,
  });

  @override
  State<ByIdKnowledgeCard> createState() => _ByIdKnowledgeCardState();
}

class _ByIdKnowledgeCardState extends State<ByIdKnowledgeCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(widget.knowledge.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.knowledge.currentUserLearning != null)
                  Text(
                      '${widget.knowledge.currentUserLearning?.calculateTimeLeft()}'),
              ],
            ),
            onTap: widget.isSelectionMode
                ? () => widget.onKnowledgeSelected(widget.knowledge)
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KnowledgeDetailScreen(knowledge: widget.knowledge),
                      ),
                    );
                  },
            trailing: widget.isSelectionMode
                ? IconButton(
                    onPressed: () =>
                        widget.onKnowledgeSelected(widget.knowledge),
                    icon: Icon(
                      widget.isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: widget.isSelected
                          ? Theme.of(context).primaryColor
                          : null,
                    ))
                : IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('confirm_deletion'.tr()),
                            content:
                                Text('are_you_sure_to_remove_knowledge_'.tr()),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('cancel'.tr()),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text('delete'.tr()),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmed == true) {
                        context.read<AddRemoveKnowledgesBloc>().add(
                              AddRemoveKnowledgesRequested(
                                AddRemoveKnowledgesRequest(
                                  isAdd: false,
                                  knowledgeIds: [widget.knowledge.id],
                                  learningListId: widget.learningListId,
                                ),
                              ),
                            );
                      }
                    },
                  ),
          ),
        ),
        Positioned(
          top: 2,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.knowledge.level.toStr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
