import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/screen_view/learning_screen_view.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import 'package:udetxen/features/learning/learning_list/screens/create_learning_list_screen.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../widgets/learning_lists.tile.dart';

class LearningListsScreen extends StatefulWidget {
  static route() {
    return LearningScreenView.route(1);
  }

  const LearningListsScreen({super.key});

  @override
  State<LearningListsScreen> createState() => _LearningListsScreenState();
}

class _LearningListsScreenState extends State<LearningListsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GetLearningListsBloc>()
        .add(GetLearningListsRequested(learningLists: null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<GetLearningListsBloc, GetLearningListsState>(
            builder: (context, state) {
              if (state is GetLearningListsLoading) {
                return const Center(child: Loading());
              } else if (state is GetLearningListsSuccess) {
                if (state.learningLists.isEmpty) {
                  return const Center(
                      child: Text('No learning lists available'));
                }
                return ListView.builder(
                  itemCount: state.learningLists.length,
                  itemBuilder: (context, index) {
                    final learningList = state.learningLists[index];
                    return LearningListsTile(
                      learningList: learningList,
                      isSelectionMode: false,
                      isSelected: false,
                      onLearningListSelected: (value) {},
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
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () =>
                  Navigator.push(context, CreateLearningListScreen.route()),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
