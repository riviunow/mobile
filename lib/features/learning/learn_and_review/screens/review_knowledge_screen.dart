import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/game_bloc.dart';
import '../blocs/get_to_review_bloc.dart';
import '../models/get_to_review.dart';
import '../widgets/game_over_board.dart';
import '../widgets/playing_header.dart';

class ReviewKnowledgeScreen extends StatefulWidget {
  final List<String> knowledgeIds;

  static route({
    required List<String> knowledgeIds,
  }) {
    return MaterialPageRoute(
      builder: (context) => ReviewKnowledgeScreen(
        knowledgeIds: knowledgeIds,
      ),
    );
  }

  const ReviewKnowledgeScreen({super.key, required this.knowledgeIds});

  @override
  State<ReviewKnowledgeScreen> createState() => _ReviewKnowledgeScreenState();
}

class _ReviewKnowledgeScreenState extends State<ReviewKnowledgeScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GetToReviewBloc>()
        .add(GetToReviewRequested(GetLearningToReviewRequest(
          knowledgeIds: widget.knowledgeIds,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<GetToReviewBloc, GetToReviewState>(
          listener: (context, state) {
            if (state is GetToReviewFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.messages.join(', '))),
              );
              Navigator.of(context).pop(false);
            }
          },
          builder: (context, state) {
            if (state is GetToReviewLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetToReviewSuccess) {
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
