import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learn_and_review/models/get_to_learn.dart';
import 'package:rvnow/features/learning/learn_and_review/services/learn_and_review_service.dart';
import 'package:rvnow/shared/models/index.dart';

import '../models/playing_widget.dart';
import '../widgets/flash_card.dart';
import '../widgets/games/word_match.dart';
import '../widgets/gaming_board.dart';
import 'game_bloc.dart';

abstract class GetToLearnEvent {
  const GetToLearnEvent();
}

class GetToLearnRequested extends GetToLearnEvent {
  final GetKnowledgesToLearnRequest request;

  const GetToLearnRequested(this.request);
}

abstract class GetToLearnState {
  const GetToLearnState();
}

class GetToLearnInitial extends GetToLearnState {}

class GetToLearnLoading extends GetToLearnState {}

class GetToLearnSuccess extends GetToLearnState {
  final List<List<Knowledge>> groupedKnowledges;

  const GetToLearnSuccess(this.groupedKnowledges);
}

class GetToLearnFailure extends GetToLearnState {
  final List<String> messages;

  const GetToLearnFailure(this.messages);
}

class GetToLearnBloc extends Bloc<GetToLearnEvent, GetToLearnState> {
  final LearnAndReviewService _learnAndReviewService;
  final GameBloc _gameBloc;

  GetToLearnBloc(this._learnAndReviewService, this._gameBloc)
      : super(GetToLearnInitial()) {
    on<GetToLearnRequested>(_onGetToLearnRequested);
  }

  Future<void> _onGetToLearnRequested(
    GetToLearnRequested event,
    Emitter<GetToLearnState> emit,
  ) async {
    emit(GetToLearnLoading());
    final response =
        await _learnAndReviewService.getKnowledgeToLearn(event.request);
    await response.on(
      onSuccess: (groupedKnowledges) {
        emit(GetToLearnSuccess(groupedKnowledges));
        _gameBloc
            .add(InitWidgetQueue(getWidgets(groupedKnowledges), Task.Learn));
      },
      onFailure: (errors, _) => emit(GetToLearnFailure(errors)),
    );
  }

  Queue<PlayingWidget> getWidgets(List<List<Knowledge>> groupedKnowledges) {
    Queue<PlayingWidget> widgets = Queue();
    for (int i = 0; i < groupedKnowledges.length; i++) {
      for (int j = 0; j < groupedKnowledges[i].length; j++) {
        // FlashCard
        widgets.add(PlayingWidget(
            type: PlayingWidgetType.FlashCard,
            widget: FlashCard(knowledge: groupedKnowledges[i][j]),
            group: i,
            knowledgeId: groupedKnowledges[i][j].id));
        if (groupedKnowledges[i][j].gamesToLearn == null) {
          continue;
        }
        for (int k = 0; k < groupedKnowledges[i][j].gamesToLearn!.length; k++) {
          // GamingBoard
          widgets.add(PlayingWidget(
              type: PlayingWidgetType.GamingBoard,
              widget: GamingBoard(
                gameKnowledgeSubscription: groupedKnowledges[i][j]
                    .gamesToLearn![k]
                    .copyWith(
                        knowledge: groupedKnowledges[i][j]
                            .copyWith(gameKnowledgeSubscriptions: [])),
              ),
              group: i,
              knowledgeId: groupedKnowledges[i][j].id));
        }
      }
      // WordMatch
      widgets.add(PlayingWidget(
          type: PlayingWidgetType.WordMatch,
          widget: WordMatch(knowledgeList: groupedKnowledges[i]),
          group: i));
    }

    return widgets;
  }
}
