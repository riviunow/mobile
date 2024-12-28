import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/game_bloc.dart';
import '../blocs/get_to_review_bloc.dart';
import '../models/get_to_review.dart';
import '../widgets/status_bar.dart';

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
        child: BlocListener<GetToReviewBloc, GetToReviewState>(
          listener: (context, state) {
            if (state is GetToReviewFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.messages.join(', '))),
              );
              Navigator.of(context).pop(false);
            }
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm'),
                            content:
                                const Text('Are you sure you want to cancel?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirm == true) {
                        context.read<GameBloc>().add(EndGameRequested());
                      }
                    },
                  ),
                  const Expanded(child: StatusBar()),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (context, state) {
                    if (state is GameInProgress) {
                      return state.widget.widget;
                    } else if (state is GameEnded) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Finish'),
                      );
                    } else if (state is GameInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const Center(
                      child: Text('No Data Available'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
