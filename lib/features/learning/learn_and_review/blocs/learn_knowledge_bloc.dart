import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/models/learn_knowledge.dart';
import 'package:udetxen/features/learning/learn_and_review/services/learn_and_review_service.dart';
import 'package:udetxen/shared/models/index.dart';

// Events
abstract class LearnKnowledgeEvent {
  const LearnKnowledgeEvent();
}

class LearnKnowledgeRequested extends LearnKnowledgeEvent {
  final LearnKnowledgeRequest request;

  const LearnKnowledgeRequested(this.request);
}

// States
abstract class LearnKnowledgeState {
  const LearnKnowledgeState();
}

class LearnKnowledgeInitial extends LearnKnowledgeState {}

class LearnKnowledgeLoading extends LearnKnowledgeState {}

class LearnKnowledgeSuccess extends LearnKnowledgeState {
  final List<Learning> learnings;

  const LearnKnowledgeSuccess(this.learnings);
}

class LearnKnowledgeFailure extends LearnKnowledgeState {
  final List<String> messages;

  const LearnKnowledgeFailure(this.messages);
}

// BLoC
class LearnKnowledgeBloc
    extends Bloc<LearnKnowledgeEvent, LearnKnowledgeState> {
  final LearnAndReviewService _learnAndReviewService;

  List<List<LearnKnowledgeParams?>> learnKnowledgeParams = [];

  LearnKnowledgeBloc(this._learnAndReviewService)
      : super(LearnKnowledgeInitial()) {
    on<LearnKnowledgeRequested>(_onLearnKnowledgeRequested);
  }

  Future<void> _onLearnKnowledgeRequested(
    LearnKnowledgeRequested event,
    Emitter<LearnKnowledgeState> emit,
  ) async {
    emit(LearnKnowledgeLoading());
    final response = await _learnAndReviewService.learnKnowledge(event.request);
    response.on(
      onSuccess: (learnings) => emit(LearnKnowledgeSuccess(learnings)),
      onFailure: (errors, _) => emit(LearnKnowledgeFailure(errors)),
    );
  }
}
