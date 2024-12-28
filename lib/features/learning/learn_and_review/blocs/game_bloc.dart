import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/blocs/learn_knowledge_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/blocs/review_learning_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/models/playing_widget.dart';
import 'package:udetxen/features/learning/learn_and_review/models/review_learning.dart';

import '../models/learn_knowledge.dart';

// States
class GameState {}

class GameInitial extends GameState {}

class GameInProgress extends GameState {
  final PlayingWidget widget;

  GameInProgress(this.widget);
}

class GameEnded extends GameState {}

// Events
class GameEvent {}

class InitWidgetQueue extends GameEvent {
  final Queue<PlayingWidget> widgets;
  final Task task;

  InitWidgetQueue(this.widgets, this.task);
}

class FlashCardFinished extends GameEvent {
  bool skipKnowledge;
  final String knowledgeId;

  FlashCardFinished(this.knowledgeId, {this.skipKnowledge = false});
}

class GameBoardFinished extends GameEvent {
  final String answerId;
  final String knowledgeId;
  final String questionId;

  GameBoardFinished(this.answerId, this.knowledgeId, this.questionId);
}

class WordMatchFinished extends GameEvent {
  final Map<String, WordMatchAnswer> knowledgeToAnswers;

  WordMatchFinished(this.knowledgeToAnswers);
}

class EndGameRequested extends GameEvent {}

// Bloc
class GameBloc extends Bloc<GameEvent, GameState> {
  final LearnKnowledgeBloc learnKnowledgeBloc;
  final ReviewLearningBloc reviewLearningBloc;
  late Task task;

  late Queue<PlayingWidget> widgets;
  late int totalKnowledges;
  int currentKnowledge = 1;
  int currentGroup = 0;
  List<String> skippedKnowledgeIds = [];

  List<Answer> answers = [];
  List<KnowledgeAnswer> knowledgeAnswers = [];

  GameBloc(this.learnKnowledgeBloc, this.reviewLearningBloc)
      : super(GameInitial()) {
    on<InitWidgetQueue>((event, emit) {
      widgets = event.widgets;
      totalKnowledges = event.widgets.length;
      task = event.task;

      knowledgeAnswers.clear();
      answers.clear();
      skippedKnowledgeIds.clear();
      currentKnowledge = 1;

      final widget = widgets.removeFirst();
      currentGroup = widget.group;

      emit(GameInProgress(widget)); // the first flash card
    });

    on<FlashCardFinished>((event, emit) {
      if (widgets.isNotEmpty) {
        PlayingWidget widget = widgets.removeFirst();
        if (event.skipKnowledge) {
          skippedKnowledgeIds.add(event.knowledgeId);
          while (widget.knowledgeId != null &&
              widget.knowledgeId == event.knowledgeId) {
            widget = widgets.removeFirst();
          }
        }

        emit(GameInProgress(widget));
      } else {
        emit(GameEnded());
      }
    });

    on<GameBoardFinished>((event, emit) {
      if (widgets.isNotEmpty) {
        answers.add(Answer(
            knowledgeId: event.knowledgeId,
            questionId: event.questionId,
            gameOptionAnswerId: event.answerId));
        final widget = widgets.removeFirst();
        if (widget.knowledgeId == null ||
            (widget.knowledgeId != null &&
                widget.knowledgeId != event.knowledgeId)) {
          knowledgeAnswers.add(KnowledgeAnswer(
              group: currentGroup,
              knowledgeId: event.knowledgeId,
              questionAnswerPair: answers
                  .map((e) => (e.questionId, e.gameOptionAnswerId))
                  .toList()));
          answers.clear();
          currentKnowledge++;
        }
        emit(GameInProgress(widget));
      } else {
        emit(GameEnded());
      }
    });

    on<WordMatchFinished>((event, emit) {
      if (task == Task.Review) {
        List<ReviewKnowledgeParams> groupedKnowledges = [];
        for (var i = 0; i < knowledgeAnswers.length; i++) {
          var knowledgeId = knowledgeAnswers[i].knowledgeId;
          groupedKnowledges.add(
            ReviewKnowledgeParams(
              knowledgeId: knowledgeId,
              questionId: knowledgeAnswers[i].questionAnswerPair[0].$1,
              answer: knowledgeAnswers[i].questionAnswerPair[0].$2,
              interpretation:
                  event.knowledgeToAnswers[knowledgeId]!.interpretation,
              wordMatchAnswer:
                  event.knowledgeToAnswers[knowledgeId]!.wordMatchAnswer,
            ),
          );
        }
        // reviewLearningBloc.add(ReviewLearningRequested(
        //     ReviewLearningRequest(groupedKnowledges: groupedKnowledges)));
      } else {
        List<LearnKnowledgeParams> groupedKnowledges = [];
        for (var i = 0; i < knowledgeAnswers.length; i++) {
          var knowledgeId = knowledgeAnswers[i].knowledgeId;
          groupedKnowledges.add(
            LearnKnowledgeParams(
              knowledgeId: knowledgeId,
              questionIdOne: knowledgeAnswers[i].questionAnswerPair[0].$1,
              answerOne: knowledgeAnswers[i].questionAnswerPair[0].$2,
              questionIdTwo: knowledgeAnswers[i].questionAnswerPair[1].$1,
              answerTwo: knowledgeAnswers[i].questionAnswerPair[1].$2,
              interpretation:
                  event.knowledgeToAnswers[knowledgeId]!.interpretation,
              wordMatchAnswer:
                  event.knowledgeToAnswers[knowledgeId]!.wordMatchAnswer,
            ),
          );
        }
        groupedKnowledges.toList();
        learnKnowledgeBloc.add(LearnKnowledgeRequested(
            LearnKnowledgeRequest(groupedKnowledges: groupedKnowledges)));
      }

      if (widgets.isEmpty) {
        emit(GameEnded());
      } else {
        final widget = widgets.removeFirst();
        currentGroup = widget.group;
        emit(GameInProgress(widget));
      }
    });

    on<EndGameRequested>((event, emit) {
      emit(GameEnded());
    });
  }
}
