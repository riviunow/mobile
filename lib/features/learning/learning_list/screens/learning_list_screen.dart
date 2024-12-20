import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/screen_view/learning_screen_view.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class LearningListScreen extends StatefulWidget {
  static route() {
    return LearningScreenView.route(1);
  }

  const LearningListScreen({super.key});

  @override
  State<LearningListScreen> createState() => _LearningListScreenState();
}

class _LearningListScreenState extends State<LearningListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetLearningListsBloc>().add(GetLearningListsRequested());
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
                    return LearningListTile(learningList: learningList);
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
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class LearningListTile extends StatelessWidget {
  final LearningList learningList;

  const LearningListTile({super.key, required this.learningList});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(learningList.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Learnt Knowledge Count: ${learningList.learntKnowledgeCount}'),
          Text(
              'Not Learnt Knowledge Count: ${learningList.notLearntKnowledgeCount}'),
          ...learningList.learningListKnowledges.map((learningListKnowledge) {
            final knowledge = learningListKnowledge.knowledge;
            return knowledge != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Knowledge Title: ${knowledge.title}'),
                      Text('Knowledge Level: ${knowledge.level}'),
                    ],
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
