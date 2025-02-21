import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/knowledge_learning/services/learning_service.dart';
import 'package:rvnow/shared/models/index.dart';
import '../models/current_user_learning.dart';

abstract class GetCurrentUserLearningsEvent {}

class FetchLearnings extends GetCurrentUserLearningsEvent {
  final GetCurrentUserLearningRequest request;

  FetchLearnings(this.request);
}

class LoadMoreLearnings extends GetCurrentUserLearningsEvent {
  final GetCurrentUserLearningRequest request;

  LoadMoreLearnings(this.request);
}

class LearningsUpdated extends GetCurrentUserLearningsEvent {
  final List<Knowledge> knowledges;

  LearningsUpdated(this.knowledges);
}

abstract class GetCurrentUserLearningsState {}

class LearningsInitial extends GetCurrentUserLearningsState {}

class LearningsLoading extends GetCurrentUserLearningsState {}

class LearningsLoaded extends GetCurrentUserLearningsState {
  final List<Knowledge> knowledges;
  final bool hasNext;

  LearningsLoaded(this.knowledges, this.hasNext);
}

class LearningsError extends GetCurrentUserLearningsState {
  final List<String> messages;

  LearningsError({this.messages = const []});
}

class GetCurrentUserLearningsBloc
    extends Bloc<GetCurrentUserLearningsEvent, GetCurrentUserLearningsState> {
  final LearningService _learningService;

  GetCurrentUserLearningsBloc(this._learningService)
      : super(LearningsInitial()) {
    on<FetchLearnings>((event, emit) async {
      emit(LearningsLoading());
      var response = await _learningService.getLearnings(event.request);
      await response.on(onFailure: (errors, _) {
        emit(LearningsError(messages: errors));
      }, onSuccess: (learnings) {
        var knowledges = learnings.data
            .map((e) => e.knowledge!
                .copyWith(currentUserLearning: e.copyWith(knowledge: null)))
            .toList();
        emit(LearningsLoaded(knowledges, learnings.hasNext));
      });
    });

    on<LearningsUpdated>(
        (event, emit) => emit(LearningsLoaded(event.knowledges, false)));

    on<LoadMoreLearnings>((event, emit) async {
      if (state is LearningsLoaded) {
        var currentState = state as LearningsLoaded;
        var response = await _learningService.getLearnings(event.request);
        await response.on(onFailure: (errors, _) {
          emit(LearningsError(messages: errors));
        }, onSuccess: (page) {
          var knowledges = page.data
              .map((e) => e.knowledge!
                  .copyWith(currentUserLearning: e.copyWith(knowledge: null)))
              .toList();
          emit(LearningsLoaded(
            currentState.knowledges + knowledges,
            page.hasNext,
          ));
        });
      }
    });
  }
}
