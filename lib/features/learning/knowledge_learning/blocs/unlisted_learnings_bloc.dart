import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/services/learning_service.dart';
import 'package:udetxen/shared/models/index.dart';

// Events
abstract class UnlistedLearningsEvent {}

class FetchUnlistedLearnings extends UnlistedLearningsEvent {
  final List<Knowledge>? knowledges;

  FetchUnlistedLearnings({this.knowledges});
}

// States
abstract class UnlistedLearningsState {}

class UnlistedLearningsInitial extends UnlistedLearningsState {}

class UnlistedLearningsLoading extends UnlistedLearningsState {}

class UnlistedLearningsLoaded extends UnlistedLearningsState {
  final List<Knowledge> knowledges;

  UnlistedLearningsLoaded(this.knowledges);
}

class UnlistedLearningsError extends UnlistedLearningsState {
  final List<String> messages;

  UnlistedLearningsError({this.messages = const []});
}

// Bloc
class UnlistedLearningsBloc
    extends Bloc<UnlistedLearningsEvent, UnlistedLearningsState> {
  final LearningService _learningService;

  UnlistedLearningsBloc(this._learningService)
      : super(UnlistedLearningsInitial()) {
    on<FetchUnlistedLearnings>((event, emit) async {
      emit(UnlistedLearningsLoading());

      if (event.knowledges != null) {
        emit(UnlistedLearningsLoaded(event.knowledges!));
        return;
      }
      var response = await _learningService.getUnlistedLearnings();
      await response.on(onFailure: (errors, _) {
        emit(UnlistedLearningsError(messages: errors));
      }, onSuccess: (learnings) {
        var knowledges = learnings
            .map((e) => e.knowledge!
                .copyWith(currentUserLearning: e.copyWith(knowledge: null)))
            .toList();
        emit(UnlistedLearningsLoaded(knowledges));
      });
    });
  }
}
