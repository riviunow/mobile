import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/exploring/knowledge/screens/knowledge_detail_screen.dart';
import 'package:rvnow/features/exploring/knowledge/widgets/knowledge_list.dart';
import 'package:rvnow/features/learning/knowledge_learning/blocs/current_user_learnings_bloc.dart';
import 'package:rvnow/features/learning/learn_and_review/screens/review_knowledge_screen.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/loader.dart';

import '../models/current_user_learning.dart';
import 'screen_view/learning_screen_view.dart';

class LearningsScreen extends StatefulWidget {
  static route() {
    return LearningScreenView.route(0);
  }

  static navigate() {
    return LearningScreenView.navigate(0);
  }

  const LearningsScreen({super.key});

  @override
  State<LearningsScreen> createState() => _LearningsScreenState();
}

class _LearningsScreenState extends State<LearningsScreen> {
  bool _isSelectionMode = false;
  final Set<Knowledge> _selectedKnowledges = {};
  List<Knowledge> _knowledges = [];

  @override
  void initState() {
    super.initState();
    context
        .read<GetCurrentUserLearningsBloc>()
        .add(FetchLearnings(GetCurrentUserLearningRequest()));
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedKnowledges.clear();
      }
    });
  }

  void _onKnowledgeSelected(Knowledge knowledge) {
    setState(() {
      if (_selectedKnowledges.any((element) => element.id == knowledge.id)) {
        _selectedKnowledges
            .removeWhere((element) => element.id == knowledge.id);
      } else {
        _selectedKnowledges.add(knowledge);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<GetCurrentUserLearningsBloc,
              GetCurrentUserLearningsState>(
            builder: (context, state) {
              if (state is LearningsLoading) {
                return const Center(child: Loading());
              } else if (state is LearningsLoaded) {
                _knowledges = state.knowledges;
                return KnowledgeList(
                    knowledges: state.knowledges,
                    hasNext: false,
                    onLoadMore: () {},
                    isSelectionMode: _isSelectionMode,
                    selectedKnowledgeIds:
                        _selectedKnowledges.map((e) => e.id).toSet(),
                    onKnowledgeSelected: _isSelectionMode
                        ? (knowledge) => _onKnowledgeSelected(knowledge)
                        : (knowledge) => Navigator.push(context,
                            KnowledgeDetailScreen.route(knowledge: knowledge)));
              } else if (state is LearningsError) {
                return Center(child: Text(state.messages.join('\n')));
              } else {
                return Center(child: Text('no_data_available'.tr()));
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary.withOpacity(0.7),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _selectedKnowledges.isEmpty
                            ? () => Navigator.push(
                                context,
                                ReviewKnowledgeScreen.route(
                                    knowledgeIds: _knowledges
                                        .where((e) =>
                                            e.currentUserLearning?.isDue ==
                                            true)
                                        .map((e) => e.id)
                                        .take(200)
                                        .toList()))
                            : _selectedKnowledges.every(
                                    (e) => e.currentUserLearning?.isDue == true)
                                ? () {
                                    Navigator.push(
                                        context,
                                        ReviewKnowledgeScreen.route(
                                            knowledgeIds: _selectedKnowledges
                                                .map((e) => e.id)
                                                .toList()));
                                    _toggleSelectionMode();
                                  }
                                : null,
                        child: Text(
                          _selectedKnowledges.isEmpty
                              ? "review".tr()
                              : _selectedKnowledges.every((e) =>
                                      e.currentUserLearning?.isDue == true)
                                  ? "${"review".tr()} (${_selectedKnowledges.length})"
                                  : "next_rv_not_due".tr(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    if (_isSelectionMode) ...[
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          Icons.settings_backup_restore,
                          color: _selectedKnowledges.isEmpty
                              ? AppColors.hint
                              : Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedKnowledges.clear();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: _toggleSelectionMode,
                      ),
                    ],
                    if (!_isSelectionMode)
                      IconButton(
                        icon: const Icon(Icons.select_all),
                        onPressed: _toggleSelectionMode,
                      ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
