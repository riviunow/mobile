import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learn_and_review/models/get_to_review.dart';
import 'package:rvnow/features/learning/learn_and_review/services/learn_and_review_service.dart';
import 'package:rvnow/shared/models/index.dart';

import '../models/playing_widget.dart';
import '../widgets/flash_card.dart';
import '../widgets/games/word_match.dart';
import '../widgets/gaming_board.dart';
import 'game_bloc.dart';

abstract class GetToReviewEvent {
  const GetToReviewEvent();
}

class GetToReviewRequested extends GetToReviewEvent {
  final GetLearningToReviewRequest request;

  const GetToReviewRequested(this.request);
}

abstract class GetToReviewState {
  const GetToReviewState();
}

class GetToReviewInitial extends GetToReviewState {}

class GetToReviewLoading extends GetToReviewState {}

class GetToReviewSuccess extends GetToReviewState {
  final List<List<Learning>> groupedLearnings;

  const GetToReviewSuccess(this.groupedLearnings);
}

class GetToReviewFailure extends GetToReviewState {
  final List<String> messages;

  const GetToReviewFailure(this.messages);
}

class GetToReviewBloc extends Bloc<GetToReviewEvent, GetToReviewState> {
  final LearnAndReviewService _learnAndReviewService;
  final GameBloc _gameBloc;

  GetToReviewBloc(this._learnAndReviewService, this._gameBloc)
      : super(GetToReviewInitial()) {
    on<GetToReviewRequested>(_onGetToReviewRequested);
  }

  Future<void> _onGetToReviewRequested(
    GetToReviewRequested event,
    Emitter<GetToReviewState> emit,
  ) async {
    emit(GetToReviewLoading());
    final response =
        await _learnAndReviewService.getLearningToReview(event.request);
    await response.on(
      onSuccess: (groupedLearnings) {
        _gameBloc
            .add(InitWidgetQueue(getWidgets(groupedLearnings), Task.Review));
        emit(GetToReviewSuccess(groupedLearnings));
      },
      onFailure: (errors, _) => emit(GetToReviewFailure(errors)),
    );
  }

  Queue<PlayingWidget> getWidgets(List<List<Learning>> groupedLearnings) {
    Queue<PlayingWidget> widgets = Queue();
    for (int i = 0; i < groupedLearnings.length; i++) {
      for (int j = 0; j < groupedLearnings[i].length; j++) {
        if (groupedLearnings[i][j].knowledge!.gameToReview != null) {
          widgets.add(PlayingWidget(
              type: PlayingWidgetType.GamingBoard,
              widget: GamingBoard(
                gameKnowledgeSubscription: groupedLearnings[i][j]
                    .knowledge!
                    .gameToReview!
                    .copyWith(
                        knowledge: groupedLearnings[i][j].knowledge!.copyWith(
                      gameKnowledgeSubscriptions: [],
                    )),
              ),
              group: i,
              knowledgeId: groupedLearnings[i][j].knowledgeId));
        }

        // FlashCard
        widgets.add(PlayingWidget(
            type: PlayingWidgetType.FlashCard,
            widget: FlashCard(knowledge: groupedLearnings[i][j].knowledge!),
            group: i,
            knowledgeId: groupedLearnings[i][j].knowledgeId));
      }
      // WordMatch
      widgets.add(PlayingWidget(
          type: PlayingWidgetType.WordMatch,
          widget: WordMatch(
              knowledgeList:
                  groupedLearnings[i].map((e) => e.knowledge!).toList()),
          group: i));
    }

    return widgets;
  }
}
