import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/services/learning_service.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/types/index.dart';
import '../models/current_user_learning.dart';

// Events
abstract class GetCurrentUserLearningsEvent {}

class FetchLearnings extends GetCurrentUserLearningsEvent {
  final GetCurrentUserLearningRequest request;

  FetchLearnings(this.request);
}

// States
abstract class GetCurrentUserLearningsState {}

class LearningsInitial extends GetCurrentUserLearningsState {}

class LearningsLoading extends GetCurrentUserLearningsState {}

class LearningsLoaded extends GetCurrentUserLearningsState {
  final Page<Learning> learnings;

  LearningsLoaded(this.learnings);
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
        emit(LearningsLoaded(learnings));
      });
    });
  }
}
