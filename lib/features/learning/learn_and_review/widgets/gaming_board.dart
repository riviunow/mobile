import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learn_and_review/widgets/games/arrange_words.dart';
import 'package:rvnow/shared/constants/games.dart';
import 'package:rvnow/shared/models/index.dart';

import '../blocs/game_bloc.dart';
import 'games/choose_correct_answer.dart';
import 'games/fill_in_blank.dart';

class GamingBoard extends StatefulWidget {
  final GameKnowledgeSubscription gameKnowledgeSubscription;

  const GamingBoard({super.key, required this.gameKnowledgeSubscription});

  @override
  State<GamingBoard> createState() => _GamingBoardState();
}

class _GamingBoardState extends State<GamingBoard> {
  void _submitAnswer(BuildContext context, String answer) {
    context.read<GameBloc>().add(GameBoardFinished(
        answer,
        widget.gameKnowledgeSubscription.knowledge!.id,
        widget.gameKnowledgeSubscription.question.id));
  }

  @override
  Widget build(BuildContext context) {
    final gameName = widget.gameKnowledgeSubscription.game?.name;

    if (gameName == null) {
      return Center(
        child: Text(
          'game_not_found'.tr(),
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    switch (gameName) {
      case Games.chooseTheCorrectAnswer:
        return ChooseCorrectAnswer(
          gameOptions: widget.gameKnowledgeSubscription.gameOptions,
          onAnswerSubmitted: (answer) => _submitAnswer(context, answer),
        );
      case Games.fillInTheBlank:
        return FillInBlank(
          gameOptions: widget.gameKnowledgeSubscription.gameOptions,
          knowledge: widget.gameKnowledgeSubscription.knowledge!,
          onAnswerSubmitted: (answer) => _submitAnswer(context, answer),
        );
      case Games.arrangeWordsLetters:
        return ArrangeWords(
          gameOptions: widget.gameKnowledgeSubscription.gameOptions,
          knowledge: widget.gameKnowledgeSubscription.knowledge!,
          onAnswerSubmitted: (answer) => _submitAnswer(context, answer),
        );
      default:
        return Center(
          child: Text(
            '${"unsupported_game".tr()}: $gameName',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
    }
  }
}
