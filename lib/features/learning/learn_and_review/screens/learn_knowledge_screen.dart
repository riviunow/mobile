import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../blocs/game_bloc.dart';
import '../blocs/get_to_learn_bloc.dart';
import '../models/get_to_learn.dart';
import '../widgets/game_over_board.dart';
import '../widgets/playing_header.dart';

class LearnKnowledgeScreen extends StatefulWidget {
  final List<String> knowledgeIds;
  final String? newLearningListTitle;

  static route({
    required List<String> knowledgeIds,
    String? newLearningListTitle,
  }) {
    return MaterialPageRoute(
      builder: (context) => LearnKnowledgeScreen(
        knowledgeIds: knowledgeIds,
        newLearningListTitle: newLearningListTitle,
      ),
    );
  }

  const LearnKnowledgeScreen(
      {super.key, required this.knowledgeIds, this.newLearningListTitle});

  @override
  State<LearnKnowledgeScreen> createState() => _LearnKnowledgeScreenState();
}

class _LearnKnowledgeScreenState extends State<LearnKnowledgeScreen> {
  @override
  void initState() {
    super.initState();
    // final bloc = context.read<GetToLearnBloc>();
    // if (bloc.state is! GetToLearnSuccess ||
    //     (bloc.state is GetToLearnSuccess &&
    //         !(bloc.state as GetToLearnSuccess).groupedKnowledges.every(
    //             (gr) => gr.every((k) => widget.knowledgeIds.contains(k.id)))))
    context
        .read<GetToLearnBloc>()
        .add(GetToLearnRequested(GetKnowledgesToLearnRequest(
          knowledgeIds: widget.knowledgeIds,
          newLearningListTitle: widget.newLearningListTitle,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<GetToLearnBloc, GetToLearnState>(
          listener: (context, state) {
            if (state is GetToLearnFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.messages.join(', '))),
              );
              Navigator.of(context).pop(false);
            }
          },
          builder: (context, state) {
            if (state is GetToLearnLoading) {
              return const Center(
                child: Loading(),
              );
            } else if (state is GetToLearnSuccess) {
              return BlocConsumer<GameBloc, GameState>(
                listener: (context, state) {
                  if (state is GameEnded && state.learnings.isEmpty) {
                    context.read<GameBloc>().add(OutGameRequested());
                    Navigator.pop(context, true);
                  }
                },
                builder: (context, state) {
                  if (state is GameInProgress) {
                    return Column(
                      children: [
                        PlayingHeader(state: state),
                        const SizedBox(height: 24),
                        Expanded(
                          child: state.widget.widget,
                        ),
                      ],
                    );
                  } else if (state is GameEnded) {
                    return GameOverBoard(learnings: state.learnings);
                  } else if (state is GameInitial) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const Center(
                    child: Text('No Data Available'),
                  );
                },
              );
            }
            return const Center(
              child: Text('No Data Available'),
            );
          },
        ),
      ),
    );
  }
}
