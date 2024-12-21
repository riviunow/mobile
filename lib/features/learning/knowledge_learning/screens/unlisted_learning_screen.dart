import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/blocs/unlisted_learnings_bloc.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import 'screen_view/learning_screen_view.dart';

class UnlistedLearningsScreen extends StatefulWidget {
  static route() {
    return LearningScreenView.route(2);
  }

  const UnlistedLearningsScreen({super.key});

  @override
  State<UnlistedLearningsScreen> createState() =>
      _UnlistedLearningsScreenState();
}

class _UnlistedLearningsScreenState extends State<UnlistedLearningsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UnlistedLearningsBloc>().add(FetchUnlistedLearnings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnlistedLearningsBloc, UnlistedLearningsState>(
      builder: (context, state) {
        if (state is UnlistedLearningsLoading) {
          return const Center(child: Loading());
        } else if (state is UnlistedLearningsLoaded) {
          return ListView.builder(
            itemCount: state.learnings.length,
            itemBuilder: (context, index) {
              final learning = state.learnings[index];
              return ListTile(
                title: Text(learning.knowledge?.title ?? ''),
              );
            },
          );
        } else if (state is UnlistedLearningsError) {
          return Center(child: Text(state.messages.join('\n')));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
