import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/add_remove_knowledges_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import 'package:udetxen/features/learning/learning_list/models/add_remove_knowledges.dart';
import 'package:udetxen/features/learning/learning_list/screens/create_learning_list_screen.dart';
import 'package:udetxen/features/learning/learning_list/screens/get_learning_list_by_id_screen.dart';
import 'package:udetxen/features/learning/learning_list/widgets/learning_lists.tile.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class LearningListDialog extends StatefulWidget {
  final List<String> knowledgeIds;

  static Route route(List<String> knowledgeIds) {
    return MaterialPageRoute(
      builder: (_) => LearningListDialog(knowledgeIds: knowledgeIds),
    );
  }

  const LearningListDialog({super.key, required this.knowledgeIds});

  @override
  State<LearningListDialog> createState() => _LearningListDialogState();
}

class _LearningListDialogState extends State<LearningListDialog> {
  LearningList? _selectedLearningList;
  bool _isLoading = false;
  String? _addedLearningListId;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<GetLearningListsBloc>();
    if (bloc.state is! GetLearningListsSuccess) {
      bloc.add(GetLearningListsRequested(learningLists: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: BlocListener<AddRemoveKnowledgesBloc, AddRemoveKnowledgesState>(
        listener: (context, state) {
          if (state is AddRemoveKnowledgesSuccess) {
            _isLoading = false;
            Navigator.pushReplacement(context,
                GetLearningListByIdScreen.route(_addedLearningListId!));
          } else if (state is AddRemoveKnowledgesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
            );
          } else if (state is AddRemoveKnowledgesLoading) {
            _isLoading = true;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: BlocBuilder<GetLearningListsBloc, GetLearningListsState>(
                builder: (context, state) {
                  if (state is GetLearningListsLoading) {
                    return const Center(child: Loading());
                  } else if (state is GetLearningListsSuccess) {
                    if (state.learningLists.isEmpty) {
                      return const Center(
                          child: Text('No learning lists available'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.learningLists.length,
                      itemBuilder: (context, index) {
                        final learningList = state.learningLists[index];
                        return LearningListsTile(
                          learningList: learningList,
                          isSelectionMode: true,
                          isSelected: _selectedLearningList != null &&
                              _selectedLearningList!.id == learningList.id,
                          onLearningListSelected: (learningList) =>
                              setState(() {
                            _selectedLearningList != null &&
                                    _selectedLearningList!.id == learningList.id
                                ? _selectedLearningList = null
                                : _selectedLearningList = learningList;
                          }),
                        );
                      },
                    );
                  } else if (state is GetLearningListsError) {
                    return Center(
                        child: Text('Error: ${state.messages.join('\n')}'));
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  CreateLearningListScreen.route(
                    knowledgeIds: widget.knowledgeIds,
                  ),
                );
                if (result == true) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Or Create Learning List"),
            ),
            ElevatedButton(
              onPressed: _selectedLearningList == null
                  ? null
                  : () {
                      _isLoading = true;
                      _addedLearningListId = _selectedLearningList!.id;
                      context.read<AddRemoveKnowledgesBloc>().add(
                            AddRemoveKnowledgesRequested(
                              AddRemoveKnowledgesRequest(
                                  learningListId: _selectedLearningList!.id,
                                  knowledgeIds: widget.knowledgeIds,
                                  isAdd: true),
                            ),
                          );
                    },
              child: _isLoading
                  ? const Loading()
                  : const Text("Done", style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}
