import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/exploring/knowledge/screens/knowledge_detail_screen.dart';
import 'package:rvnow/features/exploring/knowledge/widgets/knowledge_list.dart';
import 'package:rvnow/features/exploring/knowledge/widgets/learning_list_dialog.dart';
import 'package:rvnow/features/learning/knowledge_learning/blocs/unlisted_learnings_bloc.dart';
import 'package:rvnow/features/learning/learn_and_review/screens/review_knowledge_screen.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/loader.dart';

import 'screen_view/learning_screen_view.dart';

class UnlistedLearningsScreen extends StatefulWidget {
  static route() {
    return LearningScreenView.route(2);
  }

  static navigate() {
    return LearningScreenView.navigate(2);
  }

  const UnlistedLearningsScreen({super.key});

  @override
  State<UnlistedLearningsScreen> createState() =>
      _UnlistedLearningsScreenState();
}

class _UnlistedLearningsScreenState extends State<UnlistedLearningsScreen> {
  bool _isSelectionMode = false;
  final Set<Knowledge> _selectedKnowledges = {};
  List<Knowledge> _unlistedKnowledges = [];

  @override
  void initState() {
    super.initState();
    var bloc = context.read<UnlistedLearningsBloc>();
    if (bloc.state is! UnlistedLearningsLoaded) {
      bloc.add(FetchUnlistedLearnings());
    }
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
    return Stack(
      children: [
        BlocBuilder<UnlistedLearningsBloc, UnlistedLearningsState>(
          builder: (context, state) {
            if (state is UnlistedLearningsLoading) {
              return const Center(child: Loading());
            } else if (state is UnlistedLearningsLoaded) {
              _unlistedKnowledges = state.knowledges.toList();
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
            } else if (state is UnlistedLearningsError) {
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
                          ? () {
                              var knowledgeIdsToRv = _unlistedKnowledges
                                  .where((e) =>
                                      e.currentUserLearning?.isDue == true)
                                  .map((e) => e.id)
                                  .toList();
                              if (knowledgeIdsToRv.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    ReviewKnowledgeScreen.route(
                                        knowledgeIds: knowledgeIdsToRv));
                              }
                            }
                          : !_selectedKnowledges.every(
                                  (e) => e.currentUserLearning?.isDue == true)
                              ? null
                              : () {
                                  Navigator.push(
                                      context,
                                      ReviewKnowledgeScreen.route(
                                          knowledgeIds: _selectedKnowledges
                                              .map((e) => e.id)
                                              .toList()));
                                  _toggleSelectionMode();
                                },
                      child: Text(
                        _selectedKnowledges.isEmpty
                            ? "review".tr()
                            : "${"review".tr()} ${_selectedKnowledges.length}",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  if (_isSelectionMode) ...[
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: _selectedKnowledges.isEmpty
                          ? null
                          : () => Navigator.push(
                                context,
                                LearningListDialog.route(_selectedKnowledges
                                    .map((e) => e.id)
                                    .toList()),
                              ),
                      child: Text(
                        'add_to_list'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
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
                      icon: Icon(_selectedKnowledges.length ==
                              _unlistedKnowledges.length
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank_sharp),
                      onPressed: () {
                        setState(() {
                          if (_selectedKnowledges.length ==
                              _unlistedKnowledges.length) {
                            _selectedKnowledges.clear();
                          } else {
                            _selectedKnowledges.addAll(_unlistedKnowledges);
                          }
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
    );
  }
}
