import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/blocs/current_user_learnings_bloc.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../models/current_user_learning.dart';
import 'screen_view/learning_screen_view.dart';

class LearningsScreen extends StatefulWidget {
  static route() {
    return LearningScreenView.route(0);
  }

  const LearningsScreen({super.key});

  @override
  State<LearningsScreen> createState() => _LearningsScreenState();
}

class _LearningsScreenState extends State<LearningsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GetCurrentUserLearningsBloc>()
        .add(FetchLearnings(GetCurrentUserLearningRequest()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCurrentUserLearningsBloc,
        GetCurrentUserLearningsState>(
      builder: (context, state) {
        if (state is LearningsLoading) {
          return const Center(child: Loading());
        } else if (state is LearningsLoaded) {
          return ListView.builder(
            itemCount: state.learnings.data.length,
            itemBuilder: (context, index) {
              final learning = state.learnings.data[index];
              return ListTile(
                title: Text(learning.knowledge?.title ?? ''),
              );
            },
          );
        } else if (state is LearningsError) {
          return Center(child: Text(state.messages.join('\n')));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
