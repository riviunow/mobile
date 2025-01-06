import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/blocs/search_knowledges_bloc.dart';
import 'package:udetxen/features/exploring/subject/blocs/subject_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/blocs/current_user_learnings_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/blocs/unlisted_learnings_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/models/playing_widget.dart';
import 'package:udetxen/features/learning/learn_and_review/models/review_learning.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_list_by_id_bloc.dart';
import 'package:udetxen/shared/models/index.dart';

import '../models/learn_knowledge.dart';
import '../services/learn_and_review_service.dart';

// States
class GameState {}

class GameInitial extends GameState {}

class GameInProgress extends GameState {
  final PlayingWidget widget;

  GameInProgress(this.widget);
}

class GameEnded extends GameState {
  final List<Learning> learnings;

  GameEnded(this.learnings);
}

class GameFailure extends GameState {
  final List<String> messages;

  GameFailure(this.messages);
}

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

class OutGameRequested extends GameEvent {}

class LearningListed extends GameEvent {
  final List<String> learningIds;

  LearningListed(this.learningIds);
}

// Bloc
class GameBloc extends Bloc<GameEvent, GameState> {
  final LearnAndReviewService _learnAndReviewService;
  // TODO:
  final SubjectBloc _subjectBloc;
  final SearchKnowledgesBloc _searchKnowledgesBloc;
  final GetCurrentUserLearningsBloc _getCurrentUserLearningsBloc;
  final UnlistedLearningsBloc _unlistedLearningsBloc;
  final GetLearningListByIdBloc _getLearningListByIdBloc;

  late Task task;
  late Queue<PlayingWidget> widgets;
  late int totalKnowledges;
  int currentKnowledge = 1;
  int currentGroup = 0;
  List<String> skippedKnowledgeIds = [];
  List<Learning> learnings = [];

  List<Answer> answers = [];
  List<KnowledgeAnswer> knowledgeAnswers = [];

  GameBloc(
      this._learnAndReviewService,
      this._subjectBloc,
      this._searchKnowledgesBloc,
      this._getCurrentUserLearningsBloc,
      this._unlistedLearningsBloc,
      this._getLearningListByIdBloc)
      : super(GameInitial()) {
    on<InitWidgetQueue>((event, emit) {
      widgets = event.widgets;
      totalKnowledges = event.widgets
          .map((e) => e.knowledgeId)
          .whereType<String>()
          .toSet()
          .length;
      task = event.task;

      final widget = widgets.removeFirst();
      currentGroup = widget.group;

      emit(GameInProgress(widget));
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
        endGame(emit);
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
            task == Task.Review ||
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
        endGame(emit);
      }
    });

    on<WordMatchFinished>((event, emit) async {
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
        knowledgeAnswers.clear();

        final response = await _learnAndReviewService.reviewLearning(
            ReviewLearningRequest(groupedKnowledges: groupedKnowledges));
        await response.on(
          onSuccess: (result) {
            learnings.addAll(result);
            updateSubjectBloc(learnings);
            updateSearchKnowledgesBloc(learnings);
            updateCurrentUserLearningsBloc(learnings);
            updateUnlistedLearningsBloc(learnings);
            updateGetLearningListByIdBloc(learnings);
          },
          onFailure: (errors, _) => emit(GameFailure(errors)),
        );
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
        knowledgeAnswers.clear();
        final response = await _learnAndReviewService.learnKnowledge(
            LearnKnowledgeRequest(groupedKnowledges: groupedKnowledges));
        await response.on(
          onSuccess: (result) {
            learnings.addAll(result);
            updateSubjectBloc(learnings);
            updateSearchKnowledgesBloc(learnings);
            updateCurrentUserLearningsBloc(learnings);
            updateUnlistedLearningsBloc(learnings);
            updateGetLearningListByIdBloc(learnings);
          },
          onFailure: (errors, _) => emit(GameFailure(errors)),
        );
      }

      if (widgets.isEmpty) {
        endGame(emit);
      } else {
        final widget = widgets.removeFirst();
        currentGroup = widget.group;
        emit(GameInProgress(widget));
      }
    });

    on<EndGameRequested>((event, emit) {
      endGame(emit);
    });

    on<OutGameRequested>((event, emit) {
      clearData();
    });

    on<LearningListed>((event, emit) {
      if (state is GameEnded) {
        var state = this.state as GameEnded;
        endGame(emit,
            updatedLearnings: state.learnings
                .map((l) => event.learningIds.contains(l.id)
                    ? l.copyWith(learningListCount: 1)
                    : l)
                .toList());
      }
    });
  }

  void endGame(Emitter<GameState> emit, {List<Learning>? updatedLearnings}) {
    emit(GameEnded(updatedLearnings ?? learnings));
  }

  void clearData() {
    knowledgeAnswers.clear();
    answers.clear();
    skippedKnowledgeIds.clear();
    currentKnowledge = 1;
    learnings.clear();
  }

  void updateSubjectBloc(List<Learning> learnings) {
    if (_subjectBloc.state is SubjectLoaded) {
      final state = _subjectBloc.state as SubjectLoaded;
      _subjectBloc.add(GetSubjectById(state.subject.id,
          subject: state.subject.copyWith(
              subjectKnowledges: state.subject.subjectKnowledges
                  .map((sk) =>
                      learnings.any((l) => l.knowledgeId == sk.knowledgeId)
                          ? sk.copyWith(
                              knowledge: sk.knowledge!.copyWith(
                                currentUserLearning: learnings
                                    .firstWhere(
                                        (l) => l.knowledgeId == sk.knowledgeId)
                                    .copyWith(knowledge: null),
                              ),
                            )
                          : sk)
                  .toList())));
    }
  }

  void updateSearchKnowledgesBloc(List<Learning> learnings) {
    if (_searchKnowledgesBloc.state is KnowledgeLoaded) {
      final state = _searchKnowledgesBloc.state as KnowledgeLoaded;
      _searchKnowledgesBloc.add(SearchKnowledgesLearningUpdated(
          state.knowledges
              .map((k) => learnings.any((l) => l.knowledgeId == k.id)
                  ? k.copyWith(
                      currentUserLearning: learnings
                          .firstWhere((l) => l.knowledgeId == k.id)
                          .copyWith(
                            knowledge: null,
                          ))
                  : k)
              .toList(),
          state.hasNext));
    }
  }

  void updateCurrentUserLearningsBloc(List<Learning> learnings) {
    if (_getCurrentUserLearningsBloc.state is LearningsLoaded) {
      final state = _getCurrentUserLearningsBloc.state as LearningsLoaded;
      _getCurrentUserLearningsBloc.add(LearningsUpdated(state.knowledges
          .map((k) => learnings.any((l) => l.knowledgeId == k.id)
              ? k.copyWith(
                  currentUserLearning: learnings
                      .firstWhere((l) => l.knowledgeId == k.id)
                      .copyWith(
                        knowledge: null,
                      ))
              : k)
          .toList()));
    }
  }

  void updateUnlistedLearningsBloc(List<Learning> learnings) {
    if (_unlistedLearningsBloc.state is UnlistedLearningsLoaded) {
      final state = _unlistedLearningsBloc.state as UnlistedLearningsLoaded;
      _unlistedLearningsBloc.add(FetchUnlistedLearnings(
          knowledges: state.knowledges
              .map((k) => learnings.any((l) => l.knowledgeId == k.id)
                  ? k.copyWith(
                      currentUserLearning: learnings
                          .firstWhere((l) => l.knowledgeId == k.id)
                          .copyWith(
                            knowledge: null,
                          ))
                  : k)
              .toList()));
    }
  }

  void updateGetLearningListByIdBloc(List<Learning> learnings) {
    if (_getLearningListByIdBloc.state is GetLearningListByIdSuccess) {
      final state =
          _getLearningListByIdBloc.state as GetLearningListByIdSuccess;
      _getLearningListByIdBloc
          .add(GetLearningListByIdRequested(state.learningList.id,
              learningList: state.learningList.copyWith(
                learningListKnowledges: state
                    .learningList.learningListKnowledges
                    .map((llk) => learnings
                            .any((l) => l.knowledgeId == llk.knowledgeId)
                        ? llk.copyWith(
                            knowledge: llk.knowledge!.copyWith(
                              currentUserLearning: learnings
                                  .firstWhere(
                                      (l) => l.knowledgeId == llk.knowledgeId)
                                  .copyWith(knowledge: null),
                            ),
                          )
                        : llk)
                    .toList(),
              )));
    }
  }
}
