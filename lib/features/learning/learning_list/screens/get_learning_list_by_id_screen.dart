import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/screens/search_knowledge_screen.dart';
import 'package:udetxen/features/learning/learn_and_review/screens/learn_knowledge_screen.dart';
import 'package:udetxen/features/learning/learn_and_review/screens/review_knowledge_screen.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';
import 'package:udetxen/shared/widgets/loader.dart';
import 'package:udetxen/shared/widgets/spaced_divider.dart';

import '../blocs/add_remove_knowledges_bloc.dart';
import '../blocs/get_learning_list_by_id_bloc.dart';
import '../models/add_remove_knowledges.dart';
import '../widgets/by_id.header.dart';
import '../widgets/by_id.knowledge_card.dart';
import '../widgets/by_id.more_options.dart';

class GetLearningListByIdScreen extends StatefulWidget {
  final String learningListId;

  static route(String learningListId) {
    return MaterialPageRoute<void>(
      builder: (_) => GetLearningListByIdScreen(learningListId: learningListId),
    );
  }

  const GetLearningListByIdScreen({super.key, required this.learningListId});

  @override
  State<GetLearningListByIdScreen> createState() =>
      _GetLearningListByIdScreenState();
}

class _GetLearningListByIdScreenState extends State<GetLearningListByIdScreen> {
  bool _isSelectionMode = false;
  final Set<Knowledge> _selectedKnowledges = {};
  (List<Knowledge>, List<Knowledge>) _knowledgeIds = ([], []);
  (bool, bool) _isSelected = (false, false);

  @override
  void initState() {
    super.initState();
    final bloc = context.read<GetLearningListByIdBloc>();
    if (bloc.state is! GetLearningListByIdSuccess ||
        (bloc.state is GetLearningListByIdSuccess &&
            (bloc.state as GetLearningListByIdSuccess).learningList.id !=
                widget.learningListId)) {
      bloc.add(GetLearningListByIdRequested(widget.learningListId));
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedKnowledges.clear();
        _isSelected = (false, false);
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

  void _onSearch(GetLearningListByIdSuccess state) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchKnowledgeScreen.getInstance(
          searchFocus: true, learningListId: state.learningList.id);
    }));
    if (result == true) {
      getIt<ValueNotifier<AuthenticatedLayoutSettings>>().value =
          getIt<ValueNotifier<AuthenticatedLayoutSettings>>()
              .value
              .copyWith(initialIndex: 2, initialLearningListIndex: 1);
    }
  }

  void _onMore(LearningList learningList) async {
    var result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return ByIdMoreOptions(learningList: learningList);
      },
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<GetLearningListByIdBloc, GetLearningListByIdState>(
              builder: (context, state) {
                if (state is GetLearningListByIdLoading) {
                  return const Center(child: Loading());
                } else if (state is GetLearningListByIdSuccess) {
                  final learningList = state.learningList;
                  _knowledgeIds = (
                    learningList.notLearntKnowledges,
                    learningList.learntKnowledges
                  );

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ByIdHeader(
                            onBack: () => Navigator.pop(context),
                            onSearch: () => _onSearch(state),
                            onMore: () => _onMore(state.learningList),
                            onSelect: _toggleSelectionMode,
                            isSelectionMode: _isSelectionMode),
                        const SizedBox(height: 4),
                        Text(learningList.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        if (learningList.noKnowledge) ...[
                          const Text('No knowledge items in this list.'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _onSearch(state),
                            child: const Text('Add Knowledge'),
                          ),
                        ] else
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(16.0),
                              children: [
                                if (learningList
                                    .notLearntKnowledges.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Not Learnt Knowledges',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (_isSelectionMode)
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected.$1
                                                    ? _selectedKnowledges
                                                        .removeAll(learningList
                                                            .notLearntKnowledges)
                                                    : _selectedKnowledges
                                                        .addAll(learningList
                                                            .notLearntKnowledges);
                                                _isSelected = (
                                                  !_isSelected.$1,
                                                  _isSelected.$2
                                                );
                                              });
                                            },
                                            icon: Icon(_isSelected.$1
                                                ? Icons.check_box
                                                : Icons
                                                    .check_box_outline_blank),
                                            iconSize: 32)
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...learningList.notLearntKnowledges
                                      .map((knowledge) {
                                    return ByIdKnowledgeCard(
                                      knowledge: knowledge,
                                      learningListId: learningList.id,
                                      isSelectionMode: _isSelectionMode,
                                      isSelected: _selectedKnowledges.any(
                                          (element) =>
                                              element.id == knowledge.id),
                                      onKnowledgeSelected: _onKnowledgeSelected,
                                    );
                                  }),
                                ],
                                if (learningList
                                        .notLearntKnowledges.isNotEmpty &&
                                    learningList.learntKnowledges.isNotEmpty)
                                  const SpacedDivider(spacing: 26),
                                if (learningList
                                    .learntKnowledges.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Learnt Knowledges',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (_isSelectionMode)
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected.$2
                                                    ? _selectedKnowledges
                                                        .removeAll(learningList
                                                            .learntKnowledges)
                                                    : _selectedKnowledges
                                                        .addAll(learningList
                                                            .learntKnowledges);
                                                _isSelected = (
                                                  _isSelected.$1,
                                                  !_isSelected.$2
                                                );
                                              });
                                            },
                                            icon: Icon(_isSelected.$2
                                                ? Icons.check_box
                                                : Icons
                                                    .check_box_outline_blank),
                                            iconSize: 32)
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...learningList.learntKnowledges
                                      .map((knowledge) {
                                    return ByIdKnowledgeCard(
                                      knowledge: knowledge,
                                      learningListId: learningList.id,
                                      isSelectionMode: _isSelectionMode,
                                      isSelected: _selectedKnowledges.any(
                                          (element) =>
                                              element.id == knowledge.id),
                                      onKnowledgeSelected: _onKnowledgeSelected,
                                    );
                                  }),
                                ],
                                const SizedBox(height: 26),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                } else if (state is GetLearningListByIdError) {
                  return Center(
                      child: Text('Error: ${state.messages.join('\n')}'));
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            if (_isSelectionMode)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (_knowledgeIds.$1.isNotEmpty) ...[
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.secondary.withOpacity(0.8),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _selectedKnowledges.isEmpty
                                  ? () => Navigator.push(
                                      context,
                                      LearnKnowledgeScreen.route(
                                          knowledgeIds: _knowledgeIds.$1
                                              .map((e) => e.id)
                                              .toList()))
                                  : !_selectedKnowledges.every(
                                          (e) => e.currentUserLearning == null)
                                      ? null
                                      : () => Navigator.push(
                                          context,
                                          LearnKnowledgeScreen.route(
                                              knowledgeIds: _selectedKnowledges
                                                  .map((e) => e.id)
                                                  .toList())),
                              child: Text(
                                _selectedKnowledges.isEmpty
                                    ? "Learn"
                                    : "Learn ${_selectedKnowledges.length}",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (_knowledgeIds.$2.isNotEmpty) ...[
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.secondary.withOpacity(0.8),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _selectedKnowledges.isEmpty
                                  ? () {
                                      var knowledgeIdsToRv = _knowledgeIds.$2
                                          .where((e) =>
                                              e.currentUserLearning?.isDue ==
                                              true)
                                          .map((e) => e.id)
                                          .toList();
                                      knowledgeIdsToRv.isEmpty
                                          ? null
                                          : () => Navigator.push(
                                              context,
                                              ReviewKnowledgeScreen.route(
                                                  knowledgeIds:
                                                      knowledgeIdsToRv));
                                    }
                                  : !_selectedKnowledges.every((e) =>
                                          e.currentUserLearning?.isDue == true)
                                      ? null
                                      : () => Navigator.push(
                                          context,
                                          ReviewKnowledgeScreen.route(
                                              knowledgeIds: _selectedKnowledges
                                                  .map((e) => e.id)
                                                  .toList())),
                              child: Text(
                                _selectedKnowledges.isEmpty
                                    ? "Review"
                                    : "Review ${_selectedKnowledges.length}",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _selectedKnowledges.isEmpty
                                ? null
                                : () async {
                                    final bool? confirmed =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: Text(
                                              'Are you sure you want to remove ${_selectedKnowledges.length} knowledge(s) from the list?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmed == true) {
                                      context
                                          .read<AddRemoveKnowledgesBloc>()
                                          .add(
                                            AddRemoveKnowledgesRequested(
                                              AddRemoveKnowledgesRequest(
                                                isAdd: false,
                                                knowledgeIds:
                                                    _selectedKnowledges
                                                        .map((e) => e.id)
                                                        .toList(),
                                                learningListId:
                                                    widget.learningListId,
                                              ),
                                            ),
                                          );
                                      _toggleSelectionMode();
                                    }
                                  },
                            child: const Text("Remove"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.warning.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedKnowledges.clear();
                              });
                            },
                            child: const Text("Clear"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.warning.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _toggleSelectionMode,
                            child: const Text("Cancel"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
