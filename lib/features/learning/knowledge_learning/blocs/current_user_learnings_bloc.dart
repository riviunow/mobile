import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/services/learning_service.dart';
import 'package:udetxen/shared/models/index.dart';
import '../models/current_user_learning.dart';

// Events
abstract class GetCurrentUserLearningsEvent {}

class FetchLearnings extends GetCurrentUserLearningsEvent {
  final GetCurrentUserLearningRequest request;

  FetchLearnings(this.request);
}

class LearningsUpdated extends GetCurrentUserLearningsEvent {
  final List<Knowledge> knowledges;

  LearningsUpdated(this.knowledges);
}

// States
abstract class GetCurrentUserLearningsState {}

class LearningsInitial extends GetCurrentUserLearningsState {}

class LearningsLoading extends GetCurrentUserLearningsState {}

class LearningsLoaded extends GetCurrentUserLearningsState {
  final List<Knowledge> knowledges;

  LearningsLoaded(this.knowledges);
}

class LearningsError extends GetCurrentUserLearningsState {
  final List<String> messages;

  LearningsError({this.messages = const []});
}

// Bloc
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
        emit(LearningsLoaded(knowledges));
      });
    });

    on<LearningsUpdated>(
        (event, emit) => emit(LearningsLoaded(event.knowledges)));
  }
}
